/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012-2014 AquaPi Developers
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
#include <syslog.h>
#include <mysql.h>
#include "aquapi.h"
#include "tcpip.c"
#include "database.c"
#include "externals.c"
#include "inifile.c"

void termination_handler(int signum)	{
	if( signum ) {
		syslog(LOG_ERR, "Daemon exited abnormally.");
		Log("Praca daemona została przerwana",E_CRIT);
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
		printf("[%s] %2i %s\n",timef,lev,msg);
	}
	
	if (lev >= 0 && lev != E_SQL) {
		sprintf(query,"INSERT INTO logs (log_date,log_level,log_value) VALUES (%ld,%i,'%s');",rawtime,lev,msg);
		DB_Query(query);
	}
}

void StoreTempStat() {
	time_t rawtime;
	char buff[200];
	time ( &rawtime );
	int x;

	for(x = 0; x <= interfaces_count; x++) {
		if (interfaces[x].type == DEV_INPUT) {
			sprintf(buff,"INSERT INTO stats (stat_date, stat_interfaceid, stat_value) VALUES (%ld, %d, %.2f)",rawtime, interfaces[x].id, interfaces[x].measured_value);
			DB_Query(buff);							
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
	interfaces_count = 	-1;
	mysql_query(conn, "SELECT interface_id,interface_address,interface_name,interface_type,interface_corr FROM interfaces WHERE interface_disabled = 0 AND interface_deleted = 0");
	result = mysql_store_result(conn);
	while ((row = mysql_fetch_row(result))) {
		interfaces_count++;
		interfaces[interfaces_count].id = atof(row[0]);
		memcpy(interfaces[interfaces_count].address,row[1],sizeof(interfaces[interfaces_count].address));
		memcpy(interfaces[interfaces_count].name,row[2],sizeof(interfaces[interfaces_count].name));
		interfaces[interfaces_count].type = atof(row[3]);
		interfaces[interfaces_count].correction = atof(row[4]);
	}	
	mysql_free_result(result);	
	
	// domyślnie wyjścia na stan nieustalony
	for(x = 0; x <= interfaces_count; x++) {
		if (interfaces[x].type == DEV_OUTPUT) {
			interfaces[x].state = -1;
			interfaces[x].new_state = -1;
			interfaces[x].override_value = -1;
			interfaces[x].override_expire = -1;
		}
		if (interfaces[x].type == DEV_INPUT) {
			interfaces[x].measured_value = -200;
		}		
	}

	// Wczytanie timerów
	Log("Wczytanie timerów",E_DEV);
	timers_count = 	-1;
	mysql_query(conn, "SELECT timer_type,timer_timeif,timer_action,timer_interfaceidthen,timer_direction,timer_value,timer_interfaceidif,timer_days FROM timers ORDER BY timer_timeif ASC");
	result = mysql_store_result(conn);
	while ((row = mysql_fetch_row(result))) {
		timers_count++;
		timers[timers_count].type = atof(row[0]);
		if (row[1] != NULL) {
			timers[timers_count].timeif = atof(row[1]);
		}
		timers[timers_count].action = atof(row[2]);
		timers[timers_count].interfaceidthen = atof(row[3]);
		timers[timers_count].direction = atof(row[4]);
		if (row[5] != NULL) {
			timers[timers_count].value = atof(row[5]);
		}
		if (row[6] != NULL) {
			timers[timers_count].interfaceidif = atof(row[6]);
		}		
		memcpy(timers[timers_count].days,row[7],sizeof(timers[timers_count].days));
	}	
	mysql_free_result(result);	
	
	Log("Konfiguracja odczytana",E_DEV);
	
	SetupPorts();
}


int main() {

	char buff[200];
	time_t rawtime;
	struct tm * timeinfo;
	char *pidfile = NULL;
	FILE *pidf;
	int fval = 0;
	int x,y,z,seconds_since_midnight,last_sec_run = 0;

	// defaults
	config.dontfork 	= 0;
	config.dummy_temp_sensor_val = -100;
	config.temp_freq 	= 10; // co ile sekund kontrolować temp
	config.devel_freq 	= 30; // co ile sekund wypluwać informacje devel
	config.stat_freq 	= 600; // co ile sekund zapisywac co się dzieje w bazie
	config.reload_freq  = -1; // co ile robić przeładowanie konfiguracji (-1 oznacza że tylko po otrzymaniu komendy przez IPC)
	config.interface 	= "127.0.0.1";	// domyślny adres IP na którym demon ma nasłuchiwać połączeń
	config.port			=  6580;		// domyślny port na którym demon ma nasłuchiwać

    if (ini_parse("/etc/aquapi.ini", handler, &config) < 0) {
        printf("Can't load '/etc/aquapi.ini'\n");
        exit(1);
    }
	
	openlog(APPNAME, 0, LOG_INFO | LOG_CRIT | LOG_ERR);
	syslog(LOG_INFO, "Daemon started.");

	DB_Open(config.db_host, config.db_user, config.db_password, config.db_database);
	
	Log("Daemon uruchomiony",E_WARN);
	sprintf(buff,"Kompilacja daemona: %s %s",build_date,build_time);
	Log(buff,E_DEV);

	ReadConf();
	
	//InitIPC();
	InitTCP();
	
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
	
	// termination signals handling
	signal(SIGINT, termination_handler);
	signal(SIGTERM, termination_handler);
	
	for (;;) {	
		// ustalenie timerów i ustalenie czy jest dzien czy noc
		time ( &rawtime );
		timeinfo = localtime ( &rawtime );
		seconds_since_midnight = timeinfo->tm_hour * 3600 + timeinfo->tm_min * 60 + timeinfo->tm_sec;

		// procesuj komunikaty IPC
		//ProcessIPC();
		
		// sprawdź czy w tej sekundzie już sprawdzałeś timery i resztę
		if (seconds_since_midnight != last_sec_run) {
			// nie sprawdzałeś, to sprawdzaj
			last_sec_run = seconds_since_midnight;
			
			// obsługa temperatury
			if (seconds_since_midnight % config.temp_freq == 0) {
				for(x = 0; x <= interfaces_count; x++) {
					if (interfaces[x].type == DEV_INPUT) {
						interfaces[x].measured_value = ReadTempFromSensor(interfaces[x].address, interfaces[x].correction);
					}
				}
			}
			
			// Dobra, spróbujmy przelecieć timery i określić jaki powinien być stan wyjść
			// przebieg 1 to dzień -1
			for (x=0; x <= timers_count; x++) {
				if (timers[x].type == TRIGGER_TIME) {
					for (y=0; y <= interfaces_count; y++) {
						if (timers[x].interfaceidthen == interfaces[y].id) {
							interfaces[y].new_state = timers[x].action;
						}
					}
				}
			}
			
			// przebieg 2 to przebieg dla dnia bierzącego
			for (x=0; x <= timers_count; x++) {
				if (strncmp(timers[x].days+timeinfo->tm_wday,"1",1)  == 0) { // kontrola dnia tygodnia
					for (y=0; y <= interfaces_count; y++) {
						// teraz trzeba wziąść pod uwagę jeszcze czas
						if ((timers[x].type == TRIGGER_TIME) && (timers[x].timeif <= seconds_since_midnight)) {
							if (timers[x].interfaceidthen == interfaces[y].id) {
								interfaces[y].new_state = timers[x].action;
							}
						}
						// w tym przebiegu weź też pod uwagę wskazania sensorów
						if (timers[x].type == TRIGGER_SENSOR) {
							if (timers[x].interfaceidthen == interfaces[y].id) {
								// teraz znajdź mi jeszcze urządzenie z wartością odniesienia....
								for (z=0; z <= interfaces_count; z++) {
									if (timers[x].interfaceidif == interfaces[z].id) {
										//ignoruj stany nieustalone
										if (interfaces[z].measured_value > -100) { 
											if ((timers[x].direction == DIRECTION_BIGGER) && (interfaces[z].measured_value > timers[x].value)) {
												interfaces[y].new_state = timers[x].action;
											}
											if ((timers[x].direction == DIRECTION_SMALLER) && (interfaces[z].measured_value < timers[x].value)) {
												interfaces[y].new_state = timers[x].action;
											}
										}
									}
								}
							}
						}
					}
				}
			}	
			
			// timery załatwione, to teraz faktycznie zmień stan portów (jeśli potrzeba)
			for(x = 0; x <= interfaces_count; x++) {
				if ((interfaces[x].state != interfaces[x].new_state) && (interfaces[x].new_state != -1)) {
					// konieczna jest zmiana stanu wyjścia
					interfaces[x].state = interfaces[x].new_state;
					ChangePortState(interfaces[x].address,interfaces[x].state);
					if (interfaces[x].state == 1) {
						sprintf(buff,"Załączam %s",interfaces[x].name);
					} else {
						sprintf(buff,"Wyłączam %s",interfaces[x].name);
					}
					Log(buff,E_INFO);					
				}
			}		
			
			// informacje devel
			if (seconds_since_midnight % config.devel_freq == 0) {
				Log("========== Zrzut interfaceów ==========",E_DEV);
				Log("|Tp|St|Wartos|Nazwa",E_DEV);
				Log("----------------------------------------------------",E_DEV);
				for(x = 0; x <= interfaces_count; x++) {
					sprintf(buff,"|%2i|%2i|%+6.1f|%s",interfaces[x].type,interfaces[x].state,interfaces[x].measured_value,interfaces[x].name);
					Log(buff,E_DEV);
				}	
				Log("========== Zrzut timerów ==========",E_DEV);				
				sprintf(buff,"Liczba timerów: %i",timers_count+1);
				Log(buff,E_DEV);	
				Log("========== Koniec zrzutu ==========",E_DEV);
			}

			if (seconds_since_midnight % config.stat_freq == 0) {
				StoreTempStat();
			}

			if ((seconds_since_midnight % config.reload_freq == 0) && (config.reload_freq != -1)) {
				Log("Automatyczne odświerzenie konfiguracji",E_DEV);
				ReadConf();
			}
			
			#warning Dla zgodności z daemonem PHP. Do wyrzucenia i przerobienia na IPC
			sprintf(buff,"UPDATE settings SET setting_value=%ld WHERE setting_key = 'demon_last_activity'",rawtime);
			DB_Query(buff);		
		}
		usleep(100000);
		//sleep(1);
	} 
	DB_Close();
	return 0;
}

