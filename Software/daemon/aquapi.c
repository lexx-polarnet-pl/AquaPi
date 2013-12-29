/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012-2013 AquaPi Developers
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
 * $Id$
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
#include "database.c"
#include "externals.c"
#include "inifile.c"
#include "ipc.c"

//double temp_dzien,temp_noc,temp_cool,histereza;
//double temp_sensor_corr;
//char main_temp_sensor[80];
//char light_port[30];
//char cooling_port[30];
//char heater_port[30];

void termination_handler(int signum)	{
	// przy wychodzeniu wyłącz grzałkę
	//ChangePortState(heater_port,0);
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
		printf("[%s] %i %s\n",timef,lev,msg);
	}
	
	if (lev >= 0 && lev != E_SQL) {
		sprintf(query,"INSERT INTO logs (log_date,log_level,log_value) VALUES (%ld,%i,'%s');",rawtime,lev,msg);
		DB_Query(query);
	}
}


void StoreTempStat(double t_zad) {
	time_t rawtime;
	double temp_act = -200;
	//char temp_sensor[80];
	char buff[200];
	//char *pos;
	MYSQL_RES *result;
	MYSQL_ROW row;
	time ( &rawtime );
	int i, index=0;
	char sensors [10] [3] [21]; //ilosc macierzy, elementów w macierzy, max dlugosc elementu

	
	sprintf(buff,"INSERT INTO temp_stats (time_st,sensor_id,temp) VALUES (%ld,0,%.2f);",rawtime,t_zad);
	DB_Query(buff);	
	
	
	mysql_query(conn, "SELECT sensor_id, sensor_address, sensor_corr FROM sensors WHERE sensor_id>0 AND sensor_deleted=0;");
	result = mysql_store_result(conn);
	while ((row = mysql_fetch_row(result)))
	{
		strncpy(sensors[index][0], row[0], sizeof sensors[index][0] - 1);
		sensors[index][0][20] = '\0';
//		printf("sensors[%d][0]=%s \n", index, sensors[index][0]);

		strncpy(sensors[index][1], row[1], sizeof sensors[index][1] - 1);
		sensors[index][1][20] = '\0';
//		printf("sensors[%d][1]=%s \n", index, sensors[index][1]);

		strncpy(sensors[index][2], row[2], sizeof sensors[index][2] - 1);
		sensors[index][2][20] = '\0';
//		printf("sensors[%d][2]=%s \n", index, sensors[index][2]);

		index++;
	}	
	mysql_free_result(result);
	
	//petla dla kazdego czujnika start
	for(i = 0; i < index; i++)
	{
		//sensors[*][0] => sensor_id
		//sensors[*][1] => sensor_address
		//sensors[*][2] => sensor_corr
		temp_act = ReadTempFromSensor(sensors[i][1], atof(sensors[i][2]));
		sprintf(buff,"INSERT INTO temp_stats (time_st,sensor_id,temp) VALUES (%ld, %d, %.2f);",rawtime, atoi(sensors[i][0]), temp_act);
		DB_Query(buff);	
	}
	
	//petla dla kazdego czujnika koniec
	
}

void ReadConf() {
	MYSQL_RES *result;
	MYSQL_ROW row;	
	int x;

	Log("Odczyt konfiguracji",E_DEV);
	
	// Wczytanie interfeaców
	Log("Wczytanie interfeaców",E_DEV);
	interfaces_count = 	-1;
	mysql_query(conn, "SELECT interface_id,interface_address,interface_name,interface_type FROM interfaces WHERE interface_disabled = 0 AND interface_deleted = 0");
	result = mysql_store_result(conn);
	while ((row = mysql_fetch_row(result))) {
		interfaces_count++;
		interfaces[interfaces_count].id = atof(row[0]);
		memcpy(interfaces[interfaces_count].address,row[1],sizeof(interfaces[interfaces_count].address));
		memcpy(interfaces[interfaces_count].name,row[2],sizeof(interfaces[interfaces_count].name));
		interfaces[interfaces_count].type = atof(row[3]);
	}	
	mysql_free_result(result);	
	
	// domyślnie wyjścia na stan nieustalony
	for(x = 0; x <= interfaces_count; x++) {
		if (interfaces[x].type == DEV_OUTPUT) {
			interfaces[x].state = -1;
			interfaces[x].new_state = -1;
		}
	}

	// Wczytanie timerów
	Log("Wczytanie timerów",E_DEV);
	timers_count = 	-1;
	mysql_query(conn, "SELECT timer_type,timer_timeif,timer_action,timer_interfaceidthen FROM timers ORDER BY timer_timeif ASC");
	result = mysql_store_result(conn);
	while ((row = mysql_fetch_row(result))) {
		timers_count++;
		timers[timers_count].type = atof(row[0]);
		if (row[1] != NULL) {
			timers[timers_count].timeif = atof(row[1]);
		}
		timers[timers_count].action = atof(row[2]);
		timers[timers_count].interfaceidthen = atof(row[3]);
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
	int x,y,seconds_since_midnight,last_sec_run = 0;

	// defaults
	config.dontfork 	= 0;
	config.dummy_temp_sensor_val = -100;
	config.temp_freq 	= 10; // co ile sekund kontrolować temp
	config.devel_freq 	= 30; // co ile sekund wypluwać informacje devel
	config.stat_freq 	= 600; // co ile sekund zapisywac co się dzieje w bazie

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
	
	InitIPC();
	
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
		ProcessIPC();
		
		// sprawdź czy w tej sekundzie już sprawdzałeś timery i resztę
		if (seconds_since_midnight != last_sec_run) {
			// nie sprawdzałeś, to sprawdzaj
			last_sec_run = seconds_since_midnight;
			
			// Dobra, spróbujmy przelecieć timery i określić jaki powinien być stan wyjść
			// przebieg 1 to dzień -1
			for (x=0; x <= timers_count; x++) {
				if (timers[x].type == TRIGGER_TIME) {
					for (y=0; y <= interfaces_count; y++) {
						if (timers[x].interfaceidthen == interfaces[y].id) {
							interfaces[y].new_state = timers[x].action;
							//printf("Przebieg 1, ID: %i ST: %i\n",interfaces[y].id,interfaces[y].state);
						}
					}
				}
			}
			// przebieg 2 to przebieg dla dnia bierzącego, teraz trzeba wziąść pod uwagę jeszcze czas
			for (x=0; x <= timers_count; x++) {
				if ((timers[x].type == TRIGGER_TIME) && (timers[x].timeif <= seconds_since_midnight)) {
					for (y=0; y <= interfaces_count; y++) {
						if (timers[x].interfaceidthen == interfaces[y].id) {
							interfaces[y].new_state = timers[x].action;
							//printf("Przebieg 2, ID: %i ST: %i\n",interfaces[y].id,interfaces[y].state);
						}
					}
				}
			}	
			// timery czasowe załatwione, to teraz faktycznie zmień stan portów (jeśli potrzeba)
			for(x = 0; x <= interfaces_count; x++) {
				if ((interfaces[x].state != interfaces[x].new_state) && (interfaces[x].new_state != -1)) {
					// konieczna jest zmiana stanu wyjścia
					interfaces[x].state = interfaces[x].new_state;
					ChangePortState(interfaces[x].address,interfaces[x].state);
					sprintf(buff,"Zmiana stanu wyjścia %s na %i",interfaces[x].name,interfaces[x].state);
					Log(buff,E_INFO);					
				}
			}		
			/*
			for(i = 0; i <= events_count; i++) {
				// sprawdź czy jest odpowiedni dzień tygodnia
				if (events[i].day_of_week & (int)round(pow(2,timeinfo->tm_wday))) {
					// tm_wday -> days since Sunday	0-6
					// takie todo
					if (events[i].start<events[i].stop) { // przypadek kiedy zdarzenie zaczyna się i kończy tego samego dnia
						if ((seconds_since_midnight >= events[i].start) && (seconds_since_midnight < events[i].stop)) {
							events[i].enabled = 1;
						} else {
							events[i].enabled = 0;
						}
					} else { // przypadek kiedy zdarzenie przechodzi przez północ
						if ((seconds_since_midnight < events[i].start) && (seconds_since_midnight >= events[i].stop)) {
							events[i].enabled = 0;
						} else {
							events[i].enabled = 1;
						}
					}
				}
			}

			// domyślnie wyjścia wyłączone
			for(j = 0; j <= outputs_count; j++) {
				outputs[j].new_state = 0;
			}

			// ustalenie jaki powinien być stan wyjść uniwersalnych (timery przecież mogą się nakładać)
			for(i = 0; i <= events_count; i++) {
				if (events[i].enabled == 1) {
						for(j = 0; j <= outputs_count; j++) {
							if (strcmp(outputs[j].device,events[i].device)==0) {
								outputs[j].new_state = 1;
							}
						}
				}
			}
			
			// ustalenie czy wymagana jest zmiana stanu logicznego wyjść
			for(j = 0; j <= outputs_count; j++) {
				if (outputs[j].enabled != outputs[j].new_state) {
					outputs[j].enabled = outputs[j].new_state;
					sprintf(buff,"INSERT INTO output_stats (time_st,event,state) VALUES (%ld,'%s',%i);",rawtime,outputs[j].device,outputs[j].enabled);
					DB_Query(buff);					
					ChangePortState (outputs[j].output_port,outputs[j].enabled);
				}
			}

			// zmiana trybu dzień - noc
			if (events[0].enabled != dzien) {
				dzien = events[0].enabled;
				if (dzien == 1) {
					Log("Przechodzę w tryb dzień",E_INFO);
				} else {
					Log("Przechodzę w tryb noc",E_INFO);
				}
				sprintf(buff,"INSERT INTO output_stats (time_st,event,state) VALUES (%ld,'light',%i);",rawtime,dzien);
				DB_Query(buff);					
				ChangePortState(light_port,dzien);
			}
			
			// obsługa temperatury
			if (seconds_since_midnight % config.temp_freq == 0) {
				if (dzien == 1) {
					temp_zad = temp_dzien; 
				} else {
					temp_zad = temp_noc; 
				}
			
				temp_zal = temp_zad - histereza / 2;
				temp_wyl = temp_zad + histereza / 2;	
				temp_zal_cool = temp_cool + histereza / 2;
				temp_wyl_cool = temp_cool - histereza / 2;				


				temp_act = ReadTempFromSensor(main_temp_sensor, temp_sensor_corr);
				
				if (temp_act < -100) {
					grzanie = 0;
					chlodzenie = 0;
					ChangePortState(heater_port,grzanie);
					ChangePortState(cooling_port,chlodzenie);
				} else {
					if ((temp_act < temp_zal) && (grzanie == 0)) {
						grzanie = 1;
						//Log("Włączam grzanie",E_INFO);
						sprintf(buff,"INSERT INTO output_stats (time_st,event,state) VALUES (%ld,'heater',1);",rawtime);
						DB_Query(buff);		
						ChangePortState(heater_port,grzanie);
					} 
					if ((temp_act > temp_wyl) && (grzanie == 1)) {
						grzanie = 0;
						//Log("Wyłączam grzanie",E_INFO);
						sprintf(buff,"INSERT INTO output_stats (time_st,event,state) VALUES (%ld,'heater',0);",rawtime);
						DB_Query(buff);					
						ChangePortState(heater_port,grzanie);
					} 
					if ((temp_act < temp_wyl_cool) && (chlodzenie == 1)) {
						chlodzenie = 0;
						//Log("Wyłączam chłodzenie",E_INFO);
						sprintf(buff,"INSERT INTO output_stats (time_st,event,state) VALUES (%ld,'cooling',0);",rawtime);
						DB_Query(buff);		
						ChangePortState(cooling_port,chlodzenie);			
					} 
					if ((temp_act > temp_zal_cool) && (chlodzenie == 0)) {
						chlodzenie = 1;
						//Log("Włączam chłodzenie",E_INFO);
						sprintf(buff,"INSERT INTO output_stats (time_st,event,state) VALUES (%ld,'cooling',1);",rawtime);
						DB_Query(buff);					
						ChangePortState(cooling_port,chlodzenie);			
					} 				
				}
			}*/

			if (seconds_since_midnight % config.devel_freq == 0) {
				Log("========== Zrzut interfaceów ==========",E_DEV);
				Log("|Tp|St|Nazwa",E_DEV);
				Log("----------------------------------------------------",E_DEV);
				for(x = 0; x <= interfaces_count; x++) {
					sprintf(buff,"|%2i|%2i|%s",interfaces[x].type,interfaces[x].state,interfaces[x].name);
					Log(buff,E_DEV);
				}	
				Log("========== Zrzut timerów ==========",E_DEV);				
				sprintf(buff,"Liczba timerów: %i",timers_count+1);
				Log(buff,E_DEV);	
				Log("========== Koniec zrzutu ==========",E_DEV);
			}

			//if (seconds_since_midnight % config.stat_freq == 0) {
			//	StoreTempStat(temp_zad);
			//}
			
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

