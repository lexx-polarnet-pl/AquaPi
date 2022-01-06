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

int ChangePortStatePWMGpio(char *port,int state) {
	char buff[200];
	// numer GPIO jest za ostatnim :
	port=strrchr(port,':')+1;
	pwmWrite(atoi(port),state*1024/100);
	sprintf(buff,"Port GPIO %i Stan PWM: %i%%",atoi(port),state);
	Log(buff,E_DEV);
	return 0;
}

int ChangePortStatePwmPCA9685(char *port,int state) {
	char buff[200];
	// numer GPIO jest za ostatnim :
	port=strrchr(port,':')+1;
	pwmWrite(atoi(port),state*4096/100);
	sprintf(buff,"Port PCA9685 %i Stan PWM: %i%%",atoi(port),state);
	Log(buff,E_DEV);
	return 0;
}

int ChangePortStatePCA9685(char *port,int state) {
	char buff[200];
	// numer GPIO jest za ostatnim :
	port=strrchr(port,':')+1;
	if (state == 0) {
		pwmWrite(atoi(port),0);
	} else {
		pwmWrite(atoi(port),4096);
	}
	sprintf(buff,"Port PCA9685 %i Stan: %i",atoi(port),state);
	Log(buff,E_DEV);
	return 0;
}

int ReadPortStatePWMPCA9685(char *port) {
	port=strrchr(port,':')+1;
	return analogRead(atoi(port));
}

int ReadPortStatePCA9685(char *port) {
	port=strrchr(port,':')+1;
	return digitalRead(atoi(port));
}

int ChangePortStateDummy(char *port,int state) {
	char buff[200];
	sprintf(buff,"Port %s Stan: %i",port,state);
	Log(buff,E_DEV);
	return(0);
}

int ChangePortStateTxtFile(char *port,int state) {
	port=strrchr(port,':')+1;
    FILE *f;
    f = fopen(port, "a");
    fprintf(f, "%i\n", state);
    fclose(f);
	return(0);
}

int ChangePortStatePWMTxtFile(char *port,int state) {
	char buff[200];
	port=strrchr(port,':')+1;
    FILE *f;
    f = fopen(port, "a");
	if (f == NULL) {
		sprintf(buff,"Nie udało się otworzyć pliku %s w trybie do zapisu.",port);
		Log(buff,E_WARN);	
		return(-1);
    } else {
		fprintf(f, "PWM:%i%%\n", state);
		fclose(f);
		return(0);
	}
}

void ChangePortState (char *port,int state) {
	char buff[200];
	if (strncmp(port,PORT_DUMMY_PREFIX,strlen(PORT_DUMMY_PREFIX))==0) {
		ChangePortStateDummy(port,state);
	} else if ((strncmp(port,PORT_RPI_GPIO_PREFIX,strlen(PORT_RPI_GPIO_PREFIX))==0) && hardware.RaspiBoardVer > 0) {
		ChangePortStateGpio(port,state);
	} else if (strncmp(port,PORT_RPI_I2C_PCA9685_PREFIX,strlen(PORT_RPI_I2C_PCA9685_PREFIX))==0) {
		ChangePortStatePCA9685(port,state);
	} else if (strncmp(port,PORT_TEXT_FILE_PREFIX ,strlen(PORT_TEXT_FILE_PREFIX ))==0) {
		ChangePortStateTxtFile(port,state);
	} else {
		sprintf(buff,"CPS: Nie obsługiwany port: %s",port);
		Log(buff,E_WARN);
	}
}

void ChangePortStatePWM (char *port,int state) {
	char buff[200];
	if (strncmp(port,PORT_DUMMY_PREFIX,strlen(PORT_DUMMY_PREFIX))==0) {
		ChangePortStateDummy(port,state);	
	} else if ((strncmp(port,PORT_RPI_GPIO_PREFIX,strlen(PORT_RPI_GPIO_PREFIX))==0) && hardware.RaspiBoardVer > 0) {
		ChangePortStatePWMGpio(port,state);
	} else if (strncmp(port,PORT_RPI_I2C_PCA9685_PREFIX,strlen(PORT_RPI_I2C_PCA9685_PREFIX))==0) {
		ChangePortStatePwmPCA9685(port,state);
	} else if (strncmp(port,PORT_TEXT_FILE_PREFIX ,strlen(PORT_TEXT_FILE_PREFIX ))==0) {
		ChangePortStatePWMTxtFile(port,state);
	} else {
		sprintf(buff,"CPSP: Nie obsługiwany port: %s",port);
		Log(buff,E_WARN);
	}
}

int ReadPortState (char *port) {
	char buff[200];
	int RetVal = -1;
	if (strncmp(port,PORT_DUMMY_PREFIX,strlen(PORT_DUMMY_PREFIX))==0) {
		//RetVal = ReadPortStateDummy(port);
		RetVal = 0;
	} else if ((strncmp(port,PORT_RPI_GPIO_PREFIX,strlen(PORT_RPI_GPIO_PREFIX))==0) && hardware.RaspiBoardVer > 0) {
		RetVal = ReadPortStateGpio(port);
	} else if (strncmp(port,PORT_RPI_I2C_PCA9685_PREFIX,strlen(PORT_RPI_I2C_PCA9685_PREFIX))==0) {
		RetVal = ReadPortStatePCA9685(port);
	} else if (strncmp(port,PORT_TEXT_FILE_PREFIX ,strlen(PORT_TEXT_FILE_PREFIX ))==0) {
		RetVal = 0;
	} else {
		sprintf(buff,"RPS: Nie obsługiwany port: %s",port);
		Log(buff,E_WARN);
	}
	return RetVal;
}

int ReadPortPWMState (char *port) {
	char buff[200];
	int RetVal = -1;
	if (strncmp(port,PORT_DUMMY_PREFIX,strlen(PORT_DUMMY_PREFIX))==0) {
		RetVal = 0;
	} else if ((strncmp(port,PORT_RPI_GPIO_PREFIX,strlen(PORT_RPI_GPIO_PREFIX))==0) && hardware.RaspiBoardVer > 0) {
		// nothing to do here
	} else if (strncmp(port,PORT_RPI_I2C_PCA9685_PREFIX,strlen(PORT_RPI_I2C_PCA9685_PREFIX))==0) {
		RetVal = ReadPortStatePWMPCA9685(port);
	} else if (strncmp(port,PORT_TEXT_FILE_PREFIX ,strlen(PORT_TEXT_FILE_PREFIX ))==0) {
		// nothing to do here
	} else {
		sprintf(buff,"RPPS: Nie obsługiwany port: %s",port);
		Log(buff,E_WARN);
	}
	return RetVal;
}