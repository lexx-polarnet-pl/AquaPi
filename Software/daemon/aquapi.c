/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012-2020 AquaPi Developers
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License Version 2 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
 * USA.
 *
 */
 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <wiringPi.h>
#include <unistd.h>
#include <time.h>
#include <sys/time.h>
#include <syslog.h>
#include <mysql.h>
#include <signal.h>
#include "aquapi.h"
#include "tcpip.c"
#include "database.c"
#include "externals.c"
#include "inifile.c"
#include "light.c"
#include "temperature.c"
#include "co2.c"
#include "timers.c"

void termination_handler(int signum)	{
	if( signum ) {
		syslog(LOG_ERR, "Daemon exited abnormally.");
		//Log("Praca daemona została przerwana",E_CRIT);
	} else {
		syslog(LOG_INFO, "Daemon exited.");
		Log("Daemon zakończył pracę",E_WARN);
	}
	exit(signum);
}

void Log(char *msg, int lev) {
	time_t rawtime;
	struct tm * timeinfo;
	char timef[80];
	char query[120];
	
	time ( &rawtime );
	
	// log na ekran
	if ( config.dontfork ) {
		timeinfo = localtime ( &rawtime );
		strftime (timef,80,"%H:%M:%S",timeinfo);
		printf("\x1b[33m[%s] ",timef);	// timestamp na żółto
		if (lev==E_DEV) {
				printf("\x1b[34mDEVEL ");
		} else if (lev==E_INFO) {
				printf("\x1b[32mINFO  ");
		} else if (lev==E_WARN) {
				printf("\x1b[33mWARN  ");
		} else if (lev==E_CRIT) {
				printf("\x1b[31mCRIT  ");
		} else if (lev==E_SQL) {
				printf("\x1b[31mSQLER ");
		}
		printf("\x1b[39m%s\n",msg);
	}
	
	if (lev >= 0 && lev != E_SQL) {
		sprintf(query,"INSERT INTO logs (log_date,log_level,log_value) VALUES (%ld,%i,'%s')",rawtime,lev,msg);
		DB_Query(query);
	}
	
	// Tego rodzaju błędy wrzucaj w sysloga
	if ((lev == E_SQL) || (lev == E_CRIT) || (lev == E_WARN)) {
		syslog(LOG_ERR, msg);
	}
}

void StoreTempStat() {
	time_t rawtime;
	char buff[200];
	time ( &rawtime );
	int x;

	for(x = 0; x <= interfaces_count; x++) {
		if (interfaces[x].type == DEV_INPUT) {
			if (interfaces[x].measured_value > -100) {
				sprintf(buff,"INSERT INTO stats (stat_date, stat_interfaceid, stat_value) VALUES (%ld, %d, %.2f)",rawtime, interfaces[x].id, interfaces[x].measured_value);
				DB_Query(buff);
			} else {
				sprintf(buff,"INSERT INTO stats (stat_date, stat_interfaceid, stat_value) VALUES (%ld, %d, null)",rawtime, interfaces[x].id);
				DB_Query(buff);
			}
		}
	}
}

void ReadConf() {
	MYSQL_RES *result;
	MYSQL_ROW row;
	int x;

	Log("Odczyt konfiguracji",E_DEV);
	
	// Wczytanie interface'ów
	Log("Wczytanie interface'ów",E_DEV);
	interfaces_count = -1;
	DB_Query("SELECT interface_id,interface_address,interface_name,interface_type,interface_conf FROM interfaces WHERE interface_deleted = 0");
	result = mysql_store_result(conn);
	while ((row = mysql_fetch_row(result))) {
		interfaces_count++;
		interfaces[interfaces_count].id = atof(row[0]);
		memcpy(interfaces[interfaces_count].address,row[1],sizeof(interfaces[interfaces_count].address));
		memcpy(interfaces[interfaces_count].name,row[2],sizeof(interfaces[interfaces_count].name));
		interfaces[interfaces_count].type = atof(row[3]);
		if (row[4] != NULL) {
			interfaces[interfaces_count].conf = atof(row[4]);
		} else {
			interfaces[interfaces_count].conf = 0;
		}
	}	
	mysql_free_result(result);
	
	// domyślnie wyjścia na stan nieustalony
	for(x = 0; x <= interfaces_count; x++) {
		if (interfaces[x].type == DEV_OUTPUT || interfaces[x].type == DEV_OUTPUT_PWM) {
			interfaces[x].state = -1;
			interfaces[x].new_state = -1;
			interfaces[x].override_value = -1;
			interfaces[x].override_expire = -1;
			interfaces[x].was_error_last_time = -1;
		}
		if (interfaces[x].type == DEV_INPUT) {
			interfaces[x].measured_value = -200;
			interfaces[x].was_error_last_time = -1;
		}		
	}

	// wczytanie konfiguracji pozostałych modułów
	ModTimers_ReadSettings();
	ModLight_ReadSettings();
	ModTemperature_ReadSettings();
	ModCo2_ReadSettings();
	
	Log("Konfiguracja odczytana",E_DEV);

	SetupPorts();
}

void ProcessPortStates() {
	int x;
	char buff[200];
	time_t rawtime;
	time ( &rawtime );

	for(x = 0; x <= interfaces_count; x++) {
		//zacznij od sprawdzenia czy pracujemy w trybie auto
		if (interfaces[x].override_value != -1) {
			// tryb manualny
			if (interfaces[x].state != interfaces[x].override_value) {
				// konieczna jest zmiana stanu wyjścia
				interfaces[x].state = interfaces[x].override_value;					
				if (interfaces[x].conf == 0) {
					ChangePortState(interfaces[x].address,interfaces[x].state);
				} else {
					ChangePortState(interfaces[x].address,1-interfaces[x].state);
				}
				if (interfaces[x].state == 1) {
					sprintf(buff,"Załączam ręcznie %s",interfaces[x].name);
				} else {
					sprintf(buff,"Wyłączam ręcznie %s",interfaces[x].name);
				}
				Log(buff,E_INFO);	
				sprintf(buff,"INSERT INTO stats (stat_date, stat_interfaceid, stat_value) VALUES (%ld, %d, %i)",rawtime, interfaces[x].id, interfaces[x].state);
				DB_Query(buff);				
			}
		} else {
			if ((interfaces[x].state != interfaces[x].new_state) && (interfaces[x].new_state != -1)) {
				// konieczna jest zmiana stanu wyjścia
				interfaces[x].state = interfaces[x].new_state;
				if (interfaces[x].type == DEV_OUTPUT) {
					if (interfaces[x].conf == 0) {
						ChangePortState(interfaces[x].address,interfaces[x].state);
					} else {
						ChangePortState(interfaces[x].address,1-interfaces[x].state);
					}
					if (interfaces[x].state == 1) {
						sprintf(buff,"Załączam %s",interfaces[x].name);
					} else {
						sprintf(buff,"Wyłączam %s",interfaces[x].name);
					}
				}
				if (interfaces[x].type == DEV_OUTPUT_PWM) {
					if (interfaces[x].conf == 0) {
						ChangePortStatePWM(interfaces[x].address,interfaces[x].state);
					} else {
						ChangePortStatePWM(interfaces[x].address,100-interfaces[x].state);
					}
					sprintf(buff,"Ustawiam PWM na %i%% dla wyjścia %s",interfaces[x].state,interfaces[x].name);
				} 
				Log(buff,E_INFO);	
				sprintf(buff,"INSERT INTO stats (stat_date, stat_interfaceid, stat_value) VALUES (%ld, %d, %i)",rawtime, interfaces[x].id, interfaces[x].state);
				DB_Query(buff);				
			}
		}
	}	
}

void Externals_Debug() {
	char buff[200];
	int x;
	Log("════════════════════════ Zrzut interfaceów ════════════════════════",E_DEV);
	Log("┌───┬───────┬───────┬────┬────────────────────────────── Wejścia ──",E_DEV);
	Log("│ID │Wartość│Surowa │Błąd│Nazwa",E_DEV);
	Log("├───┼───────┼───────┼────┼─────────────────────────────────────────",E_DEV);				
	for(x = 0; x <= interfaces_count; x++) {
		if (interfaces[x].type == DEV_INPUT) {
			sprintf(buff,"│%3i│%+7.1f│%+7.1f│%4i│%s",interfaces[x].id,interfaces[x].measured_value,interfaces[x].raw_measured_value,interfaces[x].was_error_last_time,interfaces[x].name);
			Log(buff,E_DEV);
		}
	}	
	Log("└───┴───────┴───────┴────┴─────────────────────────────────────────",E_DEV);	
	Log("┌───┬──────┬──────┬──────┬─────┬─────┬────┬───────────── Wyjścia ──",E_DEV);
	Log("│ID │Stan  │NowySt│ Conf │Overr│OvExp│Błąd│Nazwa",E_DEV);
	Log("├───┼──────┼──────┼──────┼─────┼─────┼────┼────────────────────────",E_DEV);				
	for(x = 0; x <= interfaces_count; x++) {
		if (interfaces[x].type == DEV_OUTPUT) {
			sprintf(buff,"│%3i│%6i│%6i│%+6.1f│%5i│%5i│%4i│%s",interfaces[x].id,interfaces[x].state,interfaces[x].new_state,interfaces[x].conf,interfaces[x].override_value,interfaces[x].override_expire,interfaces[x].was_error_last_time,interfaces[x].name);
			Log(buff,E_DEV);
		}
	}					
	Log("└───┴──────┴──────┴──────┴─────┴─────┴────┴────────────────────────",E_DEV);		
	Log("┌───┬──────┬──────┬──────┬─────┬─────┬────┬───────── Wyjścia PWM ──",E_DEV);
	Log("│ID │Stan  │NowySt│ Conf │Overr│OvExp│Błąd│Nazwa",E_DEV);
	Log("├───┼──────┼──────┼──────┼─────┼─────┼────┼────────────────────────",E_DEV);				
	for(x = 0; x <= interfaces_count; x++) {
		if (interfaces[x].type == DEV_OUTPUT_PWM) {
			sprintf(buff,"│%3i│%6i│%6i│%+6.1f│%5i│%5i│%4i│%s",interfaces[x].id,interfaces[x].state,interfaces[x].new_state,interfaces[x].conf,interfaces[x].override_value,interfaces[x].override_expire,interfaces[x].was_error_last_time,interfaces[x].name);
			Log(buff,E_DEV);
		}
	}					
	Log("└───┴──────┴──────┴──────┴─────┴─────┴────┴────────────────────────",E_DEV);	
}

//void catch_alarm(int sig) {
void process() {
	int x;
	time_t rawtime;
	struct tm * timeinfo;
	
	time ( &rawtime );
	timeinfo = localtime ( &rawtime );	
	// użyjemy tej procedury żeby łapać wywołanie systemowe, i ustawimy timer żeby wykonywała się co sekundę żeby móc procesować rzeczy związane z obsługą AquaPi
	
	// ustalenie timerów i ustalenie czy jest dzien czy noc
	time ( &rawtime );
	timeinfo = localtime ( &rawtime );
	specials.seconds_since_midnight = timeinfo->tm_hour * 3600 + timeinfo->tm_min * 60 + timeinfo->tm_sec;

	// sprawdź czy w tej sekundzie już sprawdzałeś timery i resztę, lub czy nie otrzymałeś komendy z zewnątrz na którą trzeba zareagować
	if (specials.seconds_since_midnight != specials.last_sec_run) {
		// nie sprawdzałeś, to sprawdzaj
		specials.last_sec_run = specials.seconds_since_midnight;

		// obsługa wejść
		if (specials.seconds_since_midnight % config.inputs_freq == 0) {
			for(x = 0; x <= interfaces_count; x++) {
				if (interfaces[x].type == DEV_INPUT) {
					interfaces[x].raw_measured_value = GetDataFromInput(x);
					interfaces[x].measured_value = interfaces[x].raw_measured_value;
				}
			}
		}
		
		// Załatw ustawienia oświetlenia, temperatury i co2
		ModTimers_Process();
		ModLight_Process();
		ModTemperature_Process();
		ModCo2_Process();
		
		// wszystko załatwione, to teraz faktycznie zmień stan portów (jeśli potrzeba)
		ProcessPortStates();
		
		// informacje devel
		if (specials.seconds_since_midnight % config.devel_freq == 0) {
			Externals_Debug();
			ModTimers_Debug();
			ModLight_Debug();
			ModTemperature_Debug();
			ModCo2_Debug();
		}

		if (specials.seconds_since_midnight % config.stat_freq == 0) {
			StoreTempStat();
		}

		if ((specials.seconds_since_midnight % config.reload_freq == 0) && (config.reload_freq != -1)) {
			Log("Automatyczne odświerzenie konfiguracji",E_DEV);
			ReadConf();
		}
	}
	
	//signal(sig, catch_alarm);
}

int main() {
	char buff[200];
	//struct itimerval intold;
	//struct itimerval intnew;
	char *pidfile = NULL;
	FILE *pidf;
	int fval = 0;

	// defaults
	config.dontfork 	= 0;
	config.inputs_freq 	= 1;		// co ile sekund kontrolować wejścia
	config.devel_freq 	= 30;		// co ile sekund wypluwać informacje devel
	config.stat_freq 	= 600;		// co ile sekund zapisywac co się dzieje w bazie
	config.reload_freq	= -1;		// co ile robić przeładowanie konfiguracji (-1 oznacza że tylko po otrzymaniu komendy przez TCP)
	config.bind_address	= "127.0.0.1";	// domyślny adres IP na którym demon ma nasłuchiwać połączeń
	config.bind_port	= 6580;		// domyślny port na którym demon ma nasłuchiwać

	if (ini_parse("/etc/aquapi.ini", handler, &config) < 0) {
		printf("Can't load '/etc/aquapi.ini'\n");
		exit(1);
	}
	
	openlog(APPNAME, 0, LOG_INFO | LOG_CRIT | LOG_ERR);
	syslog(LOG_INFO, "Daemon started.");

	DB_Init();

	Log("Daemon uruchomiony",E_WARN);
	sprintf(buff,"Kompilacja daemona: %s %s",build_date,build_time);
	Log(buff,E_DEV);
	
	HardwareDetect();
	
	ReadConf();

	if ( !config.dontfork ) {
		fval = fork();
		switch(fval) {
			case -1:
				fprintf(stderr, "Fork error. Exiting.");
				termination_handler(1);
			case 0:
				setsid();
				break;
			default:
				syslog(LOG_INFO, "Daemonize. Forked child %d.", fval);
				if (pidfile != NULL && (pidf = fopen(pidfile, "w")) != NULL) {
					fprintf(pidf, "%d", fval);
					fclose(pidf);
				}
				exit(0); // parent exits
		}
	}

	InitTCP();

	// termination signals handling
	signal(SIGINT, termination_handler);
	signal(SIGTERM, termination_handler);
	/* // timer handler
	signal(SIGALRM, catch_alarm);
	
	// alarm ustawiamy co 1 sekundę a potem przechwytujemy funkcją catch_alarm 
	intnew.it_interval.tv_sec = 1;
	intnew.it_interval.tv_usec = 0;
	intnew.it_value.tv_sec = 1;
	intnew.it_value.tv_usec = 0;

	intold.it_interval.tv_sec = 0;
	intold.it_interval.tv_usec = 0;
	intold.it_value.tv_sec = 0;
	intold.it_value.tv_usec = 0;

	if (setitimer (ITIMER_REAL, &intnew, &intold) < 0)
		Log("Inicjalizacja przerwania zegarowego nieudana",E_CRIT);
	else
		Log("Przerwanie zegarowe zainicjowane",E_DEV);
 
	for (;;) sleep(1); */
	
	for (;;) {
		process();
		usleep(100000);
	}
	
	return 0;
}

