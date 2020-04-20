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
#include <pcf8574.h>
#include <ads1115.h>
#include <rb.h>
#include "inputs.c"
#include "outputs.c"

void SetPortAsOutput (char *port) {
	char buff[200];
	
	if (strncmp(port,PORT_DUMMY_PREFIX,strlen(PORT_DUMMY_PREFIX))==0) {
		// Dla portów dummy nie rób nic
	} else if ((strncmp(port,PORT_RPI_GPIO_PREFIX,strlen(PORT_RPI_GPIO_PREFIX))==0) && hardware.RaspiBoardVer > 0) {
		// numer GPIO jest za ostatnim :
		port=strrchr(port,':')+1;
		pinMode (atoi(port), OUTPUT);
	} else if (strncmp(port,PORT_RELBRD_PREFIX,strlen(PORT_RELBRD_PREFIX))==0) {
		// Relay Board - tu nie ma co robić
	} else if (strncmp(port,PORT_TEXT_FILE_PREFIX,strlen(PORT_TEXT_FILE_PREFIX))==0) {
		// Pliku tekstowego nie trzeba konfigurować jako wyjścia
	} else {
		sprintf(buff,"SPAO: Nie obsługiwany port: %s",port);
		Log(buff,E_WARN);
		// nie obsługiwany port
	}
}

void SetPortAsPwmOutput (char *port) {
	char buff[200];
	
	if (strncmp(port,PORT_DUMMY_PREFIX,strlen(PORT_DUMMY_PREFIX))==0) {
		// Dla portów dummy nie rób nic
	} else if ((strncmp(port,PORT_RPI_GPIO_PREFIX,strlen(PORT_RPI_GPIO_PREFIX))==0) && hardware.RaspiBoardVer > 0) {
		// numer GPIO jest za ostatnim :
		port=strrchr(port,':')+1;
		pinMode (atoi(port), PWM_OUTPUT);
	} else if (strncmp(port,PORT_TEXT_FILE_PREFIX,strlen(PORT_TEXT_FILE_PREFIX))==0) {
		// Pliku tekstowego nie trzeba konfigurować jako wyjścia
	} else {
		sprintf(buff,"SPAPO: Nie obsługiwany port: %s",port);
		Log(buff,E_WARN);
		// nie obsługiwany port
	}
}

void SetPortAsInput (char *port) {
	if ((strncmp(port,PORT_RPI_GPIO_PREFIX,strlen(PORT_RPI_GPIO_PREFIX))==0) && hardware.RaspiBoardVer > 0) {
		// numer GPIO jest za ostatnim :
		port=strrchr(port,':')+1;
		pinMode (atoi(port), INPUT);
	}
}

void ScanI2CBus() {
	int i;
	char buff[200];

	// najpierw szukamy expanderów i2c na pcf8574
	for (i = 0; i < 4; i++) {	// zakładamy 4 ekspandery max
		hardware.i2c_PCF8574[i].fd = wiringPiI2CSetup (PCF8574_BASE_ADDR+i);
		// nie ma innego (?) sposobu na potwierdzenie czy urządzenie istnieje niż próba zapisu
		hardware.i2c_PCF8574[i].state = wiringPiI2CWrite (hardware.i2c_PCF8574[i].fd, wiringPiI2CRead(hardware.i2c_PCF8574[i].fd)); 
		if (hardware.i2c_PCF8574[i].state != -1) {
			sprintf(buff,"Wykryty osprzęt: Expander pcf8574 o adresie %#x",PCF8574_BASE_ADDR+i);
			Log(buff,E_DEV);
			// dodatkowe porty trzeba zarejestrować
			pcf8574Setup (PCF8574_BASE_PIN+i*8,PCF8574_BASE_ADDR+i) ;
		}
	}

	// teraz poszukajmy przetworników ADC na ADS1115
	for (i = 0; i < 4; i++) {	// zakładamy 4 przetworniki max
		hardware.i2c_ADS1115[i].fd = wiringPiI2CSetup (ADS1115_BASE_ADDR+i);
		// nie ma innego (?) sposobu na potwierdzenie czy urządzenie istnieje niż próba odczytu
		hardware.i2c_ADS1115[i].state = wiringPiI2CRead(hardware.i2c_ADS1115[i].fd);
		if (hardware.i2c_ADS1115[i].state != -1) {
			sprintf(buff,"Wykryty osprzęt: Przetwornik analogowo-cyfrowy ADS1115 o adresie %#x",ADS1115_BASE_ADDR+i);
			Log(buff,E_DEV);
			// dodatkowe porty trzeba zarejestrować
			ads1115Setup (ADS1115_BASE_PIN+i*8,ADS1115_BASE_ADDR+i) ;
		}
	}
	
	//sprawdzamy czy jest obecne MinipH
	hardware.i2c_MinipH.fd = wiringPiI2CSetup(MINIPH_ADDR);
	hardware.i2c_MinipH.state = wiringPiI2CReadReg16(hardware.i2c_MinipH.fd, 0 );
	if (hardware.i2c_MinipH.state != -1) {
		Log("Wykryty osprzęt: Mostek pomiarowy MinipH",E_DEV);
	}
}
int SetupPorts() {
	int x;
	for(x = 0; x <= interfaces_count; x++) {
		if (interfaces[x].type == DEV_OUTPUT) {
			SetPortAsOutput(interfaces[x].address);
			if (interfaces[x].conf == 0) {
				interfaces[x].state = ReadPortState(interfaces[x].address);
			} else {
				interfaces[x].state = 1 - ReadPortState(interfaces[x].address);
			}			
		}
		if (interfaces[x].type == DEV_OUTPUT_PWM) {
			SetPortAsPwmOutput(interfaces[x].address);
			//if (interfaces[x].conf == 0) {
			//	interfaces[x].state = ReadPortState(interfaces[x].address);
			//} else {
			//	interfaces[x].state = 1 - ReadPortState(interfaces[x].address);
			//}			
		}
		if (interfaces[x].type == DEV_INPUT) {
			SetPortAsInput(interfaces[x].address);
		}
	}	
	//for(j = 0; j <= outputs_count; j++) {
		//SetPortAsOutput(outputs[j].output_port);
	//}
	return 0;
}

void HardwareDetect() {
	char buff[200];
	hardware.RaspiBoardVer = piBoardRev_noOops();
	if (hardware.RaspiBoardVer > 0) {
		sprintf(buff,"Wykryty osprzęt: Raspberry Pi rewizja: %i",hardware.RaspiBoardVer);
		Log(buff,E_DEV);
		wiringPiSetup();
		ScanI2CBus();
	}	

}
