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
		if (!file_exists(device_path)) {
			sprintf(buff,"Urządzenie %s nie istnieje.",device_path);
			Log(buff,E_CRIT);
			return -1;
		}
		if (RelayBoardPortInit(device_path)) {
			sprintf(buff,"Karta RelayBoard na porcie %s nie odpowiada.",device_path);
			Log(buff,E_CRIT);
			//exit(-1);
			return -1;
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

int ReadPortStateRelBrd (char *port) {
	char buff[200];
	char *pch;
	int przekaznik,ret;
	char device_path[50];
	ret = -1;
	strcpy(buff,port);
	// numer przekaźnika jest za ostanim :
	pch=strrchr(buff,':');
	przekaznik=atoi(pch+1);
	if (przekaznik<1 || przekaznik >8) {
		sprintf(buff,"Zły numer przekaźnika w definicji %s.",port);
		Log(buff,E_CRIT);
	} else {
		// obetnij ciąg na tym :
		pch[0] = 0;
		// teraz znajdź pierwszy :
		pch=strchr(buff,':');
		// i przesuń wskaźnik o 1
		pch++;
		sprintf (device_path,"/dev/%s",pch);
		if (!file_exists(device_path)) {
			sprintf(buff,"Urządzenie %s nie istnieje.",device_path);
			Log(buff,E_CRIT);
			return -1;
		}		
		if (RelayBoardPortInit(device_path)) {
			sprintf(buff,"Karta RelayBoard na porcie %s nie odpowiada.",device_path);
			Log(buff,E_CRIT);
			//exit(-1);
			return -1;
		}
		uint8_t errorValue,value;
		if ((errorValue = RelayBoardGet(ADRESS,&value))) {
			return -1;
		} else {
			ret = value;
		}
		RelayBoardPortClose();
	}
	return ret;
}

int ReadPortStateGpio(char *port) {
	// numer GPIO jest za ostatnim :
	port=strrchr(port,':')+1;
	return digitalRead (atoi(port));
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

int ReadPortState (char *port) {
	char buff[200];
	int RetVal = -1;
	if (strncmp(port,PORT_DUMMY_PREFIX,strlen(PORT_DUMMY_PREFIX))==0) {
		//RetVal = ReadPortStateDummy(port);
		RetVal = 0;
	} else if ((strncmp(port,PORT_RPI_GPIO_PREFIX,strlen(PORT_RPI_GPIO_PREFIX))==0) && RaspiBoardVer > 0) {
		RetVal = ReadPortStateGpio(port);
	} else if (strncmp(port,PORT_RELBRD_PREFIX,strlen(PORT_RELBRD_PREFIX))==0) {
		RetVal = ReadPortStateRelBrd(port);
	} else {
		sprintf(buff,"Nie obsługiwany port: %s",port);
		Log(buff,E_WARN);
	}
	return RetVal;
}
