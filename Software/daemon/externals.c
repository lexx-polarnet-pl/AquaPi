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
#include <wiringPiI2C.h>
#include <rb.h>
#include "inputs.c"
#include "outputs.c"

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
	} else if (strncmp(port,PORT_RPI_I2C_PCF8574_PREFIX,strlen(PORT_RPI_I2C_PCF8574_PREFIX))==0) {
		// i2c expander - tu też nie ma co robić		
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
			if (interfaces[x].conf == 0) {
				interfaces[x].state = ReadPortState(interfaces[x].address);
			} else {
				interfaces[x].state = 1 - ReadPortState(interfaces[x].address);
			}			
		}
	}	
	//for(j = 0; j <= outputs_count; j++) {
		//SetPortAsOutput(outputs[j].output_port);
	//}
	return 0;
}
