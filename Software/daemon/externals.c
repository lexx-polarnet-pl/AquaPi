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
#include <wiringPi.h>
#include <rb.h>
#include "inputs.c"

int wiringPiSetupFin;
int RaspiBoardVer;

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
	sprintf(buff,"Port %s Stan: %i",port,state);
	Log(buff,E_DEV);
	return(0);
}
void ChangePortState (char *port,int state) {
	char buff[200];
	if (strncmp(port,PORT_DUMMY_PREFIX,strlen(PORT_DUMMY_PREFIX))==0) {
		ChangePortStateDummy(port,state);
	} else if ((strncmp(port,PORT_RPI_GPIO_PREFIX,strlen(PORT_RPI_GPIO_PREFIX))==0) && RaspiBoardVer > 0) {
		ChangePortStateGpio(port,state);
	} else if (strncmp(port,PORT_RELBRD_PREFIX,strlen(PORT_RELBRD_PREFIX))==0) {
		ChangePortStateRelBrd (port,state);
	} else {
		sprintf(buff,"Nie obsługiwany port: %s",port);
		Log(buff,E_WARN);
	}
}

void SetPortAsOutput (char *port) {
	char buff[200];
	
	if (strncmp(port,PORT_DUMMY_PREFIX,strlen(PORT_DUMMY_PREFIX))==0) {
		// Dla portów dummy nie rób nic
	} else if ((strncmp(port,PORT_RPI_GPIO_PREFIX,strlen(PORT_RPI_GPIO_PREFIX))==0) && RaspiBoardVer > 0) {
		if (wiringPiSetupFin == 0) {
			wiringPiSetupFin = 1;
			wiringPiSetup ();
		}
		// numer GPIO jest za ostatnim :
		port=strrchr(port,':')+1;
		pinMode (atoi(port), OUTPUT);
	} else if (strncmp(port,PORT_RELBRD_PREFIX,strlen(PORT_RELBRD_PREFIX))==0) {
		// Relay Board - tu nie ma co robić
	} else {
		sprintf(buff,"Nie obsługiwany port: %s",port);
		Log(buff,E_WARN);
		// nie obsługiwany port
	}
}

int SetupPorts() {
	int x;
	wiringPiSetupFin = 0;
	RaspiBoardVer = piBoardRev_noOops();
	for(x = 0; x <= interfaces_count; x++) {
		if (interfaces[x].type == DEV_OUTPUT) {
			SetPortAsOutput(interfaces[x].address);
		}
	}	
	//for(j = 0; j <= outputs_count; j++) {
		//SetPortAsOutput(outputs[j].output_port);
	//}
	return 0;
}
