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
 * $Id:$
 */
 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <wiringPi.h>
#include <unistd.h>
#include <time.h>
#include <syslog.h>
#include "database.c"
#include "gpio.c"

#define APPNAME "AquaPi"

const int E_DEV = -1;
const int E_INFO = 0;
const int E_WARN = 1;
const int E_CRIT = 2;

void Log(char *msg, int lev);

struct _events {
	int line,start,stop,enabled;
} events; 

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
	timeinfo = localtime ( &rawtime );

	// log na ekran
	strftime (timef,80,"%H:%M:%S",timeinfo);	
	printf("[%s] %i %s\n",timef,lev,msg);
	
	if (lev >= 0) {
		sprintf(query,"INSERT INTO log (time,level,message) VALUES (%ld,%i,'%s');",rawtime,lev,msg);
		DB_Query(query);
	}
}

int main() {
	double temp_zal,temp_wyl,temp_dzien,temp_noc;
	double temp_zad = 0;
	double temp_act = -200;

	double histereza = 1.0; // przenieść do UI

	char main_temp_sensor[80];
	char buff[200];
	time_t rawtime;
	struct tm * timeinfo;

	int temp_freq = 10; // co ile sekund kontrolować temp
	int log_freq = 60; // co ile sekund wypluwać informacje devel

	int grzanie = 0;
	int dzien = -1;
	int seconds_since_midnight;
	
	openlog(APPNAME, 0, LOG_INFO | LOG_CRIT | LOG_ERR);
    syslog(LOG_INFO, "Daemon started.");
 
	DB_Open();
	Log("Daemon uruchomiony",E_INFO);
	
	DB_GetSetting("temp_day",buff);
	temp_dzien = atof(buff); 
	DB_GetSetting("temp_night",buff);
	temp_noc = atof(buff); 
	DB_GetSetting("temp_sensor",main_temp_sensor);
	
	events.line = gpio_main_light;
	DB_GetSetting("day_start",buff);
	events.start = atof(buff); 	
	DB_GetSetting("day_stop",buff);
	events.stop = atof(buff); 	
	
	GPIO_setup();

	// termination signals handling
    signal(SIGINT, termination_handler);
    signal(SIGTERM, termination_handler);
	
	for (;;) {	
		// timery i ustalenie czy jest dzien czy noc
		time ( &rawtime );
		timeinfo = localtime ( &rawtime );
		seconds_since_midnight = timeinfo->tm_hour * 3600 + timeinfo->tm_min * 60 + timeinfo->tm_sec;
		
		if (events.start<events.stop) { // przypadek kiedy zdarzenie zaczyna się i kończy tego samego dnia
		    if ((seconds_since_midnight >= events.start) && (seconds_since_midnight < events.stop)) {
				events.enabled = 1;
		    } else {
				events.enabled = 0;
		    }
		} else { // przypadek kiedy zdarzenie przechodzi przez północ
		    if ((seconds_since_midnight < events.start) && (seconds_since_midnight >= events.stop)) {
				events.enabled = 0;
		    } else {
				events.enabled = 1;
		    }
		}

		if (events.enabled != dzien) {
			dzien = events.enabled;
			if (dzien == 1) {
				Log("Przechodzę w tryb dzień",E_INFO);
				DB_Query("UPDATE data SET value=1 WHERE `key`='day';");
				temp_zad = temp_dzien; 
			} else {
				Log("Przechodzę w tryb noc",E_INFO);
				DB_Query("UPDATE data SET value=0 WHERE `key`='day';");
				temp_zad = temp_noc; 
			}
			digitalWrite (gpio_main_light, dzien);
		}
		
		// obsługa temperatury
		if (seconds_since_midnight % temp_freq == 0) {
			temp_zal = temp_zad - histereza / 2;
			temp_wyl = temp_zad + histereza / 2;	
			temp_act = read_temp(main_temp_sensor);
			
			if (temp_act < -100) {
				Log("Błąd odczytu sensora temperatury",E_CRIT);
			} else {
				if ((temp_act < temp_zal) && (grzanie == 0)) {
					grzanie = 1;
					Log("Włączam grzanie",E_INFO);
					DB_Query("UPDATE data SET value=1 WHERE `key`='heating';");
				} 
				if ((temp_act > temp_wyl) && (grzanie == 1)) {
					grzanie = 0;
					Log("Wyłączam grzanie",E_INFO);
					DB_Query("UPDATE data SET value=0 WHERE `key`='heating';");
				} 
				digitalWrite (gpio_heater, grzanie);
				sprintf(buff,"UPDATE data SET value= %.2f WHERE `key`='temp_act'", temp_act);
				DB_Query(buff);
			}
		}

		if (seconds_since_midnight % log_freq == 0) {
			sprintf(buff,"Dzień: %i Grzanie: %i Temp zad: %.2f Temp akt: %.2f",dzien,grzanie,temp_zad,temp_act);
			Log(buff,E_DEV);
		}
		
		sleep(1);
	} 
	DB_Close();
	return 0;
}

