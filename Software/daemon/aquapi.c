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
 * $Id:$
 */
 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <wiringPi.h>
#include <unistd.h>
#include <sqlite3.h>

const int gpio_heater = 1;

double histereza = 1.0;
int rc;
sqlite3 *db;
char *zErrMsg = 0;
	
double read_temp() {
    FILE *fp;
    char sensor_path[] = { "/sys/bus/w1/devices/28-000003dabe2c/w1_slave" };
    char line[80];
	char *pos;
	double temp;

    fp = fopen (sensor_path, "r");
    if( fp == NULL ) {
		perror(sensor_path);
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
		return 0;
	}
}



int DB_Open() {
	//rc = sqlite3_open("/usr/share/aquapi/aquapi.db", &db);
	rc = sqlite3_open_v2("/usr/share/aquapi/aquapi.db", &db,1,0);
	if( rc ){
		fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
		sqlite3_close(db);
		return 1;
	} else {
		printf("Baza otwarta\n");
		return 0;
	}
}

void DB_GetSetting(char *key, char *value) {
	//int s;
	const unsigned char * text;
	sqlite3_stmt * stmt;
	char query[80]= "select value from settings where key='";
	strcat(query, key);
	strcat(query, "';");

    sqlite3_prepare_v2 (db, query, strlen (query) + 1, & stmt, NULL);
	sqlite3_step (stmt);
	text  = sqlite3_column_text (stmt, 0);
    //printf ("%s\n",  text);	
	memcpy (value, text, 60);
}

int main() {
	double temp_act,temp_zal,temp_wyl;
	double temp_zad = 0;
	char buff[60];
	
	int freq = 10;
	int grzanie = 0;
	
	DB_Open();

	//buff = ;
	//printf(buff);
	

	//printf(buff);
	//printf("\n\n");
	
	GPIO_setup();
	
	for (;;) {	
		DB_GetSetting("temp_day",buff);
		temp_zad = atof(buff); 
		temp_zal = temp_zad - histereza / 2;
		temp_wyl = temp_zad + histereza / 2;	
		temp_act = read_temp();
		if ((temp_act < temp_zal) && (grzanie == 0)) {
			grzanie = 1;
			printf("wlaczam grzanie\n");
			digitalWrite (1, 1);
		} 
		if ((temp_act > temp_wyl) && (grzanie == 1)) {
			grzanie = 0;
			printf("wylaczam grzanie\n");
			digitalWrite (1, 0);
		} 
		
		printf("Grzanie: %i Temp zal: %.2f Temp wyl: %.2f Temp akt: %.2f\n",grzanie,temp_zal,temp_wyl,temp_act);
		
		sleep(freq);
	} 
	sqlite3_close(db);
}