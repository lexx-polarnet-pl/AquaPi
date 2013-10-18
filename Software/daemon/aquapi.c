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
#include "gpio.c"

int dontfork = 0;
double temp_dzien,temp_noc,temp_cool,histereza;
char main_temp_sensor[80];
char light_port[10];
char cooling_port[10];
char heater_port[10];

void ChangePortState (char *port,int state) {
	//char PortNo[2];
	char buff[200];
	if (strcmp(port,"dummy")==0) {
		// do nothing
	} else if (strncmp(port,"gpio",4)==0) {
		// przestaw wskaźnik tam gdzie powinien znajdować się numer portu
		port += 4;
		digitalWrite (atoi(port),state);
		sprintf(buff,"Port GPIO%i Stan: %i",atoi(port),state);
		Log(buff,E_DEV);		
	} else {
		sprintf(buff,"Nie obsługiwany port: %s",port);
		Log(buff,E_WARN);
		// nie obsługiwany port
	}
}

void termination_handler(int signum)	{
	// przy wychodzeniu wyłącz grzałkę
	//digitalWrite (gpio_heater, 0);
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
	if ( dontfork ) {
		timeinfo = localtime ( &rawtime );
		strftime (timef,80,"%H:%M:%S",timeinfo);	
		printf("[%s] %i %s\n",timef,lev,msg);
	}
	
	if (lev >= 0) {
		sprintf(query,"INSERT INTO log (time,level,message) VALUES (%ld,%i,'%s');",rawtime,lev,msg);
		DB_Query(query);
	}
}

int events_count,outputs_count;

struct _events {
	int line,start,stop,enabled,day_of_week;
	char device[10];
} events[500]; 

//int outputs_count = 20;

struct _outputs {
	int line,enabled,new_state;
	//char *name;
	char name[40];
	char output_port[10];
	char device[10];
} outputs[40];





double ReadTempFromSensor(char *temp_sensor) {
	int fail_count;
	double temp_act = -200;
	char buff[200];
	
	fail_count = 0;
			
	do {
		temp_act = read_temp(temp_sensor);
		if (temp_act < -100) {
			fail_count++;
		}
	} while (temp_act<-100 && fail_count <3);
			
	if (temp_act == -202) {
		sprintf(buff,"Błędy CRC przy odczycie sensora %s", temp_sensor);
		Log(buff,E_WARN);				
	}
	
	if (temp_act < -100) {
		Log("Błąd odczytu sensora temperatury",E_CRIT);
	}
	
	return temp_act;
}

void StoreTempStat(double t_zad) {
	time_t rawtime;
	double temp_act = -200;
	char temp_sensor[80];
	char buff[200];
	char *pos;
	
	time ( &rawtime );

	sprintf(buff,"INSERT INTO temp_stats (time_st,sensor_id,temp) VALUES (%ld,0,%.2f);",rawtime,t_zad);
	DB_Query(buff);	
	
	DB_GetSetting("temp_sensor",temp_sensor);
	temp_act = ReadTempFromSensor(temp_sensor);
	sprintf(buff,"INSERT INTO temp_stats (time_st,sensor_id,temp) VALUES (%ld,1,%.2f);",rawtime,temp_act);
	DB_Query(buff);	

	DB_GetSetting("temp_sensor2",temp_sensor);
	pos = strstr(temp_sensor,"none");
	if (pos == NULL) {	
		temp_act = ReadTempFromSensor(temp_sensor);
		sprintf(buff,"INSERT INTO temp_stats (time_st,sensor_id,temp) VALUES (%ld,2,%.2f);",rawtime,temp_act);
		DB_Query(buff);	
	}

	DB_GetSetting("temp_sensor3",temp_sensor);
	pos = strstr(temp_sensor,"none");
	if (pos == NULL) {	
		temp_act = ReadTempFromSensor(temp_sensor);
		sprintf(buff,"INSERT INTO temp_stats (time_st,sensor_id,temp) VALUES (%ld,3,%.2f);",rawtime,temp_act);
		DB_Query(buff);	
	}
	
	DB_GetSetting("temp_sensor4",temp_sensor);
	pos = strstr(temp_sensor,"none");
	if (pos == NULL) {	
		temp_act = ReadTempFromSensor(temp_sensor);
		sprintf(buff,"INSERT INTO temp_stats (time_st,sensor_id,temp) VALUES (%ld,4,%.2f);",rawtime,temp_act);
		DB_Query(buff);	
	}	
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
	
	DB_GetSetting("temp_sensor",main_temp_sensor);
	
	
	// wczytanie ustawień timerów
	events_count = 	0;
	mysql_query(conn, "SELECT t_start,t_stop,line,device,day_of_week FROM timers;");
	result = mysql_store_result(conn);
	while ((row = mysql_fetch_row(result))) {
		//for(i = 0; i < num_fields; i++) {
		events_count++;
		events[events_count].start = atof(row[0]);
		events[events_count].stop = atof(row[1]);
		events[events_count].line = atof(row[2]);
		memcpy(events[events_count].device,row[3],sizeof(events[events_count].device));
		events[events_count].day_of_week = atof(row[4]);
	}	
	mysql_free_result(result);
	
	// ustawienia kiedy dzień a kiedy noc są brane z innego miejsca
	events[0].line = gpio_main_light;
	//events[0].device = "light";
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

	int temp_freq = 10; // co ile sekund kontrolować temp
	int log_freq = 60; // co ile sekund wypluwać informacje devel
	int stat_freq = 600; // co ile sekund zapisywac co się dzieje w bazie
	int conf_freq = 600; // co ile sekund wczytać ustawienia z bazy

	int grzanie = 0;
	int chlodzenie = 0;
	int dzien = -1;
	int fval = 0;
	int i,j,seconds_since_midnight;

	//const char inifile[] = "/etc/aquapi.ini";
	//dontfork = 1;
	
	char db_host[] = "localhost";
	char db_user[] = "aquapi"; 
	char db_password[] = "aquapi"; 
	char db_database[] = "aquapi"; 
	
	openlog(APPNAME, 0, LOG_INFO | LOG_CRIT | LOG_ERR);
    syslog(LOG_INFO, "Daemon started.");
 
	DB_Open(db_host,db_user,db_password,db_database);
	
	Log("Daemon uruchomiony",E_WARN);
	
	ReadConf();
	
	GPIO_setup();
	
	// domyślnie wyjścia na zero
	for(j = 0; j <= outputs_count; j++) {
		outputs[j].enabled = 0;
		outputs[j].new_state = 0;
	}

	if ( !dontfork ) {
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

		// odświerzenie konfiguracji
		if (seconds_since_midnight % conf_freq== 0) {
			ReadConf();
		}
		
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
				//digitalWrite (outputs[j].line,outputs[j].enabled);
				ChangePortState (outputs[j].output_port,outputs[j].enabled);
			}
		}

		// zmiana trybu dzień - noc
		if (events[0].enabled != dzien) {
			dzien = events[0].enabled;
			if (dzien == 1) {
				Log("Przechodzę w tryb dzień",E_INFO);
				DB_Query("UPDATE data SET value=1 WHERE `key`='day';");
				sprintf(buff,"INSERT INTO output_stats (time_st,event,state) VALUES (%ld,'light',1);",rawtime);
				DB_Query(buff);					
				
			} else {
				Log("Przechodzę w tryb noc",E_INFO);
				DB_Query("UPDATE data SET value=0 WHERE `key`='day';");
				sprintf(buff,"INSERT INTO output_stats (time_st,event,state) VALUES (%ld,'light',0);",rawtime);
				DB_Query(buff);					
			}
			//digitalWrite (gpio_main_light, dzien);
			ChangePortState(light_port,dzien);
		}
		
		// obsługa temperatury
		if (seconds_since_midnight % temp_freq == 0) {
			if (dzien == 1) {
				temp_zad = temp_dzien; 
			} else {
				temp_zad = temp_noc; 
			}
		
			temp_zal = temp_zad - histereza / 2;
			temp_wyl = temp_zad + histereza / 2;	
			temp_zal_cool = temp_cool + histereza / 2;
			temp_wyl_cool = temp_cool - histereza / 2;				

			temp_act = ReadTempFromSensor(main_temp_sensor);
			
			if (temp_act < -100) {
				grzanie = 0;
				chlodzenie = 0;
				//digitalWrite (gpio_heater, grzanie);
				//digitalWrite (gpio_cool, chlodzenie);
				ChangePortState(heater_port,grzanie);
				ChangePortState(cooling_port,chlodzenie);
			} else {
				if ((temp_act < temp_zal) && (grzanie == 0)) {
					grzanie = 1;
					//Log("Włączam grzanie",E_INFO);
					DB_Query("UPDATE data SET value=1 WHERE `key`='heating';");
					sprintf(buff,"INSERT INTO output_stats (time_st,event,state) VALUES (%ld,'heater',1);",rawtime);
					DB_Query(buff);					
				} 
				if ((temp_act > temp_wyl) && (grzanie == 1)) {
					grzanie = 0;
					//Log("Wyłączam grzanie",E_INFO);
					DB_Query("UPDATE data SET value=0 WHERE `key`='heating';");
					sprintf(buff,"INSERT INTO output_stats (time_st,event,state) VALUES (%ld,'heater',0);",rawtime);
					DB_Query(buff);					
				} 
				if ((temp_act < temp_wyl_cool) && (chlodzenie == 1)) {
					chlodzenie = 0;
					//Log("Wyłączam chłodzenie",E_INFO);
					DB_Query("UPDATE data SET value=0 WHERE `key`='cooling';");
					sprintf(buff,"INSERT INTO output_stats (time_st,event,state) VALUES (%ld,'cooling',0);",rawtime);
					DB_Query(buff);					
				} 
				if ((temp_act > temp_zal_cool) && (chlodzenie == 0)) {
					chlodzenie = 1;
					//Log("Włączam chłodzenie",E_INFO);
					DB_Query("UPDATE data SET value=1 WHERE `key`='cooling';");
					sprintf(buff,"INSERT INTO output_stats (time_st,event,state) VALUES (%ld,'cooling',1);",rawtime);
					DB_Query(buff);					
				} 				
				ChangePortState(heater_port,grzanie);
				ChangePortState(cooling_port,chlodzenie);
				sprintf(buff,"UPDATE data SET value= %.2f WHERE `key`='temp_act'", temp_act);
				DB_Query(buff);
			}
		}

		if (seconds_since_midnight % log_freq == 0) {
			sprintf(buff,"Dzień: %i Grzanie: %i Temp zad: %.2f Temp akt: %.2f Hist: %.2f",dzien,grzanie,temp_zad,temp_act,histereza);
			Log(buff,E_DEV);
		}

		if (seconds_since_midnight % stat_freq == 0) {
			StoreTempStat(temp_zad);
			//sprintf(buff,"INSERT INTO stat (time_st,heat,day,temp_t,temp_a) VALUES (%ld,%i,%i,%.2f,%.2f);",rawtime,grzanie,dzien,temp_zad,temp_act);
			//DB_Query(buff);
		}
		
		sleep(1);
	} 
	DB_Close();
	return 0;
}

