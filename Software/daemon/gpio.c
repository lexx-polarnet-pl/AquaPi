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
const int gpio_uni1 = 0;
const int gpio_uni2 = 6;
const int gpio_cool = 5;

double read_temp(char *sensor_id) {
    FILE *fp;
	
    char sensor_path[200]; 
	char buff[200];
    char line[80];
	char *pos;
	double temp;

	sprintf(sensor_path,"/sys/bus/w1/devices/%s/w1_slave",sensor_id);
	
    fp = fopen (sensor_path, "r");
    if( fp == NULL ) {
		//perror(sensor_path);
		sprintf(buff,"Błąd dostępu do %s: %s", sensor_path, strerror(errno));
		Log(buff,E_CRIT);
		return -201;
    } else {
		// otwarty plik z danymi sensora, trzeba odczytac
		fgets(line, 80, fp);
		// poszukajmy YES w stringu (weryfikacja CRC ok)
		pos = strstr(line,"YES");
		if (pos != NULL) {
			fgets(line, 80, fp);
			fclose (fp);
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
		} else {
			//sprintf(buff,"Błąd CRC przy odczycie sensora %s", sensor_id);
			//Log(buff,E_WARN);
			return -202;
		}
	}
}

int GPIO_setup() {
	if (wiringPiSetup () == -1) {
		return 1;
	} else {
		pinMode (gpio_main_light, OUTPUT) ;
		pinMode (gpio_heater, OUTPUT) ;
		pinMode (gpio_cool, OUTPUT) ;
		pinMode (gpio_uni1, OUTPUT) ;
		pinMode (gpio_uni2, OUTPUT) ;
		// grzanie i chłodzenie domyślnie wyłączone
		digitalWrite (gpio_heater, 0);
		digitalWrite (gpio_cool, 0);
		return 0;
	}
}