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
#include <wiringPi.h>

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

double read_temp(char *sensor_id) {
    FILE *fp;
	
    char sensor_path[200]; 
	char buff[200];
    char line[80];
	char line2[80];
	char *pos;
	double temp;

	sprintf(sensor_path,"/sys/bus/w1/devices/%s/w1_slave",sensor_id);
	
    fp = fopen (sensor_path, "r");
    if( fp == NULL ) {
		sprintf(buff,"Błąd dostępu do %s: %s", sensor_path, strerror(errno));
		Log(buff,E_CRIT);
		return -201;
    } else {
		// otwarty plik z danymi sensora, trzeba odczytac
		fgets(line, 80, fp);
		fgets(line2, 80, fp);
		fclose (fp);		
		// poszukajmy YES w stringu (weryfikacja CRC ok)
		pos = strstr(line,"YES");
		if (pos != NULL) {
			// teraz mamy dane o temperaturze
			pos = strstr(line2,"t=");
			if (pos != NULL) {
				// przesuwamy wzkaznik o 2, na poczatek informacji o temperaturze
				pos += 2;
				temp = (double)atoi(pos)/1000;
				return temp;
			} else {
				return -200;
			}
		} else {
			//sprintf(buff,"Błąd CRC przy odczycie sensora %s", sensor_id);
			//Log(buff,E_WARN);
			return -202;
		}
	}
}

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

void SetPortAsOutput (char *port) {
	char buff[200];
	if (strcmp(port,"dummy")==0||strcmp(port,"disabled")==0) {
		// do nothing
	} else if (strncmp(port,"gpio",4)==0) {
		// przestaw wskaźnik tam gdzie powinien znajdować się numer portu
		port += 4;
		pinMode (atoi(port), OUTPUT);
	} else {
		sprintf(buff,"Nie obsługiwany port: %s",port);
		Log(buff,E_WARN);
		// nie obsługiwany port
	}
}

int SetupPorts() {
	int j;
	if (wiringPiSetup () == -1) {
		return 1;
	} else {
		for(j = 0; j <= outputs_count; j++) {
			SetPortAsOutput(outputs[j].output_port);
		}
		return 0;
	}
}
