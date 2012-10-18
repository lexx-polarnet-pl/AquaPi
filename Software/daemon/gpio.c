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
 
#include <wiringPi.h>

const int gpio_heater = 1;
const int gpio_main_light = 4;

double read_temp(char *sensor_id) {
    FILE *fp;
	
    char sensor_path[200]; 
    char line[80];
	char *pos;
	double temp;

	sprintf(sensor_path,"/sys/bus/w1/devices/%s/w1_slave",sensor_id);
	
    fp = fopen (sensor_path, "r");
    if( fp == NULL ) {
		//perror(sensor_path);
		return -201;
    } else {
		// otwarty plik z danymi sensora, trzeba odczytac
		fgets(line, 80, fp);
		// tutaj mamy dane na temat CRC, do zrobienia weryfikacja tego CRC
		fgets(line, 80, fp);
		// teraz mamy dane o temperaturze
		pos = strstr(line,"t=");
		if (pos != NULL) {
			// przesuwamy wzkaznik o 2, na poczatek informacji o temperaturze
			pos += 2;
			temp = (double)atoi(pos)/1000;
			return temp;
		} else {
			return -200;
		}
		fclose (fp);
	}
}

int GPIO_setup() {
	if (wiringPiSetup () == -1) {
		return 1;
	} else {
		// grzanie domyślnie wyłączone
		pinMode (gpio_heater, OUTPUT) ;
		digitalWrite (gpio_heater, 0);
		pinMode (gpio_main_light, OUTPUT) ;
		return 0;
	}
}