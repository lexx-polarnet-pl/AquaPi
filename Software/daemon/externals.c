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
#include <rb.h>

char *PORT_RELBRD_PREFIX = "relbrd:";
char *PORT_RPI_GPIO_PREFIX = "rpi:gpio:";
char *PORT_DUMMY_PREFIX = "dummy";

int wiringPiSetupFin;

int ChangePortStateRelBrd (char *port,int state) {
	char buff[200];
	char *pch;
	int przekaznik,ret;
	char device_path[50];
	ret = 0;
	strcpy(buff,port);
	// numer przekaźnika jest za ostanim :
	pch=strrchr(buff,':');
	przekaznik=atoi(pch+1);
	if (przekaznik<1 || przekaznik >8) {
		sprintf(buff,"Zły numer przekaźnika w definicji %s.",port);
		Log(buff,E_CRIT);
		ret = -1;
	} else {
		// obetnij ciąg na tym :
		pch[0] = 0;
		// teraz znajdź pierwszy :
		pch=strchr(buff,':');
		// i przesuń wskaźnik o 1
		pch++;
		sprintf (device_path,"/dev/%s",pch);
		if (RelayBoardPortInit(device_path)) {
			sprintf(buff,"Karta RelayBoard na porcie %s nie odpowiada.",device_path);
			Log(buff,E_CRIT);
			//exit(-1);
			ret = -1;
		}
		if (state == 0) {
			RelayBoardOff(ADRESS,przekaznik-1);
		} else {
			RelayBoardOn(ADRESS,przekaznik-1);
		}
		sprintf(buff,"Port %s Stan: %i",port,state);
		Log(buff,E_DEV);		
		RelayBoardPortClose();
	}
	return ret;
}

int ChangePortStateGpio(char *port,int state) {
	char buff[200];
	// numer GPIO jest za ostatnim :
	port=strrchr(port,':')+1;
	digitalWrite (atoi(port),state);
	sprintf(buff,"Port GPIO %i Stan: %i",atoi(port),state);
	Log(buff,E_DEV);
	return 0;
}

int ChangePortStateDummy(char *port,int state) {
	char buff[200];
	sprintf(buff,"Port DUMMY Stan: %i",state);
	Log(buff,E_DEV);
	return(0);
}
void ChangePortState (char *port,int state) {
	char buff[200];
	if (strcmp(port,PORT_DUMMY_PREFIX)==0) {
		ChangePortStateDummy(port,state);
	} else if (strncmp(port,PORT_RPI_GPIO_PREFIX,sizeof(PORT_RPI_GPIO_PREFIX)-1)==0) {
		ChangePortStateGpio(port,state);
	} else if (strncmp(port,PORT_RELBRD_PREFIX,sizeof(PORT_RELBRD_PREFIX)-1)==0) {
		ChangePortStateRelBrd (port,state);
	} else {
		sprintf(buff,"CPS - Nie obsługiwany port: %s",port);
		Log(buff,E_WARN);
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
	
	if (strcmp(sensor_id,"dummy")==0) {
		// dummy sensor
		return config.dummy_temp_sensor_val;
	} else {
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
}

double ReadTempFromSensor(char *temp_sensor, double temp_sensor_corr) {
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
	
	return temp_act+temp_sensor_corr;
}

void SetPortAsOutput (char *port) {
	char buff[200];
	
	if (strcmp(port,PORT_DUMMY_PREFIX)==0||strcmp(port,"disabled")==0) {
		// do nothing
	} else if (strncmp(port,PORT_RPI_GPIO_PREFIX,sizeof(PORT_RPI_GPIO_PREFIX)-1)==0) {
		if (wiringPiSetupFin == 0) {
			wiringPiSetupFin = 1;
			wiringPiSetup ();
		}
		pinMode (atoi(port), OUTPUT);
	} else if (strncmp(port,PORT_RELBRD_PREFIX,sizeof(PORT_RELBRD_PREFIX)-1)==0) {
		// Relay Board - tu nie ma co robić
	} else {
		sprintf(buff,"SPAO - Nie obsługiwany port: %s",port);
		Log(buff,E_WARN);
		// nie obsługiwany port
	}
}

int SetupPorts() {
	int j;
	wiringPiSetupFin = 0;
	for(j = 0; j <= outputs_count; j++) {
		SetPortAsOutput(outputs[j].output_port);
	}
	return 0;
}
