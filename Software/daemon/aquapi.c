/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012 Marcin Król (lexx@polarnet.pl)
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
#include "aquapi.h"
#include "database.c"
#include "externals.c"
#include "inifile.c"
#include "ipc.c"

double temp_dzien,temp_noc,temp_cool,histereza;
double temp_sensor_corr;
char main_temp_sensor[80];
char light_port[30];
char cooling_port[30];
char heater_port[30];

void termination_handler(int signum)	{
	// przy wychodzeniu wyłącz grzałkę
	ChangePortState(heater_port,0);
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
	
	if (lev >= 0) {
		sprintf(query,"INSERT INTO log (time,level,message) VALUES (%ld,%i,'%s');",rawtime,lev,msg);
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
	char buff[200];
	MYSQL_RES *result;
	MYSQL_ROW row;	
	
	// wczytanie ustawień temperatury
	DB_GetSetting("temp_day",buff);
	temp_dzien = atof(buff); 
	DB_GetSetting("temp_night",buff);
	temp_noc = atof(buff); 
	DB_GetSetting("hysteresis",buff);
	histereza = atof(buff); 
	DB_GetSetting("temp_cool",buff);
	temp_cool = atof(buff); 
	
	//DB_GetSetting("temp_sensor",main_temp_sensor);
	mysql_query(conn, "SELECT sensor_address FROM sensors WHERE sensor_master=1;");
	result = mysql_store_result(conn);
	row = mysql_fetch_row(result);
	strncpy(main_temp_sensor, row[0], sizeof main_temp_sensor - 1);
	main_temp_sensor[79] = '\0';
	
	
	// wczytanie ustawień timerów
	events_count = 	0;
	mysql_query(conn, "SELECT t_start,t_stop,device,day_of_week FROM timers;");
	result = mysql_store_result(conn);
	while ((row = mysql_fetch_row(result))) {
		//for(i = 0; i < num_fields; i++) {
		events_count++;
		events[events_count].start = atof(row[0]);
		events[events_count].stop = atof(row[1]);
		memcpy(events[events_count].device,row[2],sizeof(events[events_count].device));
		events[events_count].day_of_week = atof(row[3]);
	}	
	mysql_free_result(result);
	
	// ustawienia kiedy dzień a kiedy noc są brane z innego miejsca
	DB_GetSetting("day_start",buff);
	events[0].start = atof(buff); 	
	DB_GetSetting("day_stop",buff);
	events[0].stop = atof(buff); 
	events[0].day_of_week = 127;
	
	// wczytanie nazw wyjść
	outputs_count = 0;
	mysql_query(conn, "SELECT device,output FROM devices;");
	result = mysql_store_result(conn);
	while ((row = mysql_fetch_row(result))) {
		//for(i = 0; i < num_fields; i++) {
		memcpy(outputs[outputs_count].device,row[0],sizeof(outputs[outputs_count].device));
		memcpy(outputs[outputs_count].output_port,row[1],sizeof(outputs[outputs_count].output_port));
		outputs_count++;
	}	
	mysql_free_result(result);	
	outputs_count--;
	
	// wczytanie portów dla urządzeń specjalnych
	DB_GetOne("select output from devices where `device`='light';", light_port, sizeof(light_port));
	DB_GetOne("select output from devices where `device`='heater';", heater_port, sizeof(heater_port));
	DB_GetOne("select output from devices where `device`='cooling';", cooling_port, sizeof(cooling_port));
}


int main() {
	double temp_zal,temp_wyl,temp_zal_cool,temp_wyl_cool;
	double temp_zad = 0;
	double temp_act = -200;
	char buff[200];
	time_t rawtime;
	struct tm * timeinfo;
	char *pidfile = NULL;
	FILE *pidf;

	int grzanie = 0;
	int chlodzenie = 0;
	int dzien = -1;
	int fval = 0;
	int i,j,seconds_since_midnight;
	MYSQL_ROW row;

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

	ReadConf();
	
	SetupPorts();
	
	InitIPC();
	
	// domyślnie wyjścia na zero
	for(j = 0; j <= outputs_count; j++) {
		outputs[j].enabled = 0;
		outputs[j].new_state = 0;
	}

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

			//DB_GetSetting("temp_sensor_corr",buff);
			//temp_sensor_corr = atof(buff); 
			mysql_query(conn, "SELECT sensor_corr FROM sensors WHERE sensor_master=1;");
			row = mysql_fetch_row(mysql_store_result(conn));
			temp_sensor_corr=atof(row[0]);

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
		}

		if (seconds_since_midnight % config.devel_freq == 0) {
			sprintf(buff,"Dzień: %i Grzanie: %i Temp zad: %.2f Temp akt: %.2f Hist: %.2f",dzien,grzanie,temp_zad,temp_act,histereza);
			Log(buff,E_DEV);
		}

		if (seconds_since_midnight % config.stat_freq == 0) {
			StoreTempStat(temp_zad);
		}
		
		sleep(1);
	} 
	DB_Close();
	return 0;
}

