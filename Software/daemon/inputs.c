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
 
#include "miniph.c"
#include <wiringPi.h>

double read_1w_ds18b20(char *sensor_id) {
	FILE *fp;
	char sensor_path[200]; 
	char line[80];
	char line2[80];
	char *pos;
	double temp;
	
	sprintf(sensor_path,"/sys/bus/w1/devices/%s/w1_slave",sensor_id);
	fp = fopen (sensor_path, "r");
	if( fp == NULL ) {
		//sprintf(buff,"Błąd dostępu do %s: %s", sensor_path, strerror(errno));
		//Log(buff,E_CRIT);
		return -100;
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
				// sprawdź jeszcze czy temp to nie przypadkiem 85 stopni (czujnik nie dokończył inicjalizacji)
				if (temp != 85) {
					return temp;
				} else {
					//sprintf(buff,"Nie zainicjowany sensor %s", sensor_id);
					//Log(buff,E_DEV);
					return -200;
				}
			} else {
				//sprintf(buff,"Brak t= przy odczycie sensora %s", sensor_id);
				//Log(buff,E_DEV);				
				return -201;
			}
		} else {
			//sprintf(buff,"Błąd CRC przy odczycie sensora %s", sensor_id);
			//Log(buff,E_DEV);
			return -202;
		}
	}
}

double GetDataFromInput(int sensor_id) {
	
	char buff[200];
	char *SensorAddress;
	char *Sensor1WAddress;
	int fail_count;
	double ret_val;
	
	fail_count = 0; // ile podejmować prób odczytu.
	
	SensorAddress = interfaces[sensor_id].address;
	
	do {
		if (strncmp(SensorAddress,INPUT_DUMMY_PREFIX,strlen(INPUT_DUMMY_PREFIX))==0) {
			// dummy sensor
			ret_val = interfaces[sensor_id].conf;
		/*} else if (strncmp(SensorAddress,INPUT_SYSTEM_CPUTEMP,strlen(INPUT_SYSTEM_CPUTEMP))==0) { - wywalamy
			// rpi:system:cputemp sensor
			ret_val = Get_Numeric_From_File("/sys/class/thermal/thermal_zone0/temp")/1000;	*/ 
		} else if (strncmp(SensorAddress,PORT_TEXT_FILE_PREFIX,strlen(PORT_TEXT_FILE_PREFIX))==0) {
			// rpi:system:txtfile sensor
			ret_val = Get_Numeric_From_File(strrchr(SensorAddress,':')+1);			
		} else if (strncmp(SensorAddress,INPUT_RPI_1W_PREFIX,strlen(INPUT_RPI_1W_PREFIX))==0) {
			// rpi:1w:
			Sensor1WAddress=strrchr(SensorAddress,':')+1;	
			ret_val = read_1w_ds18b20(Sensor1WAddress);
		} else if (strncmp(SensorAddress,INPUT_RPI_I2C_MINIPH_PREFIX,strlen(INPUT_RPI_I2C_MINIPH_PREFIX))==0) {
			// Sensor pH
			ret_val = read_i2c_miniph();
		} else if ((strncmp(SensorAddress,PORT_RPI_GPIO_PREFIX,strlen(PORT_RPI_GPIO_PREFIX))==0) && hardware.RaspiBoardVer > 0) {
			ret_val = digitalRead(atoi(strrchr(SensorAddress,':')+1));
		} else {
			//sprintf(buff,"Nie obsługiwane wejście: %s",SensorAddress);
			//Log(buff,E_WARN);
			ret_val = -101;
		}	
		fail_count++;
	} while (ret_val <=-200 && fail_count <3); // 3 próby przy błędach typu CRC

	if (interfaces[sensor_id].was_error_last_time != 1) {
		if (ret_val == -100) {
			sprintf(buff,"Błąd dostępu do %s (%s) %s", interfaces[sensor_id].name, SensorAddress, strerror(errno));
			Log(buff,E_CRIT);
		}
		if (ret_val == -101) {
			sprintf(buff,"Nie obsługiwany sensor %s (%s)", interfaces[sensor_id].name, SensorAddress);
			Log(buff,E_CRIT);
		}	
		if (ret_val == -200) {
			sprintf(buff,"Nie zainicjowany sensor %s (%s)", interfaces[sensor_id].name, SensorAddress);
			Log(buff,E_CRIT);
		}
		if (ret_val == -201) {
			sprintf(buff,"Brak t= przy odczycie sensora %s (%s)", interfaces[sensor_id].name, SensorAddress);
			Log(buff,E_CRIT);
		}	
		if (ret_val == -202) {
			sprintf(buff,"Błąd CRC przy odczycie sensora %s (%s)", interfaces[sensor_id].name, SensorAddress);
			Log(buff,E_CRIT);
		}	
	}
	
	if (ret_val <= -100) {
		// błąd. Zapamiętaj czy wystąpił żeby więcej go nie logować
		interfaces[sensor_id].was_error_last_time = 1;
	} else {
		// nie było błędu to zapisz
		interfaces[sensor_id].was_error_last_time = 0;
	}
	
	return ret_val;
}
