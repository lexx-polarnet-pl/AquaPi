/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012-2020 AquaPi Developers
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

const int DIR_GREATER = 0;
const int DIR_SMALLER = 1;
const int NOTIFICATION_INTERVAL = 600; // minimalna przerwa między notyfikacjami to 10 min, chodzi o to, żeby nie zaśmiecać logów

struct _alarms {
	int id;
	int interface_id;
	double action_level;
	int direction;
	char text[200]; 
	int is_alarm;
	int was_alarm;
	int alarm_level;
	int last_notification;
} alarms[100];

int alarms_count;	
 
void ModAlarms_ReadSettings() {
	MYSQL_RES *result;
	MYSQL_ROW row;

	// Wczytanie alarmów
	Log("Wczytanie alertów",E_DEV);
	alarms_count = 	-1;
	DB_Query("SELECT alarm_id,alarm_interface_id,alarm_action_level,alarm_direction,alarm_text,alarm_level FROM alarms");
	result = mysql_store_result(conn);
	while ((row = mysql_fetch_row(result))) {
		alarms_count++;
		alarms[alarms_count].id = atof(row[0]);
		alarms[alarms_count].interface_id = atof(row[1]);
		alarms[alarms_count].action_level = atof(row[2]);
		alarms[alarms_count].direction = atof(row[3]);
		memcpy(alarms[alarms_count].text,row[4],sizeof(alarms[alarms_count].text));
		alarms[alarms_count].alarm_level = atof(row[5]);
		alarms[alarms_count].is_alarm = 0;
		alarms[alarms_count].was_alarm = 0;
		alarms[alarms_count].last_notification = 0;
	}	
	mysql_free_result(result);
}

void ModAlarms_Process() {		
	int x,y;
	
	// sprawdzamy, czy aktualnie powinien być alert
	for (x=0; x <= alarms_count; x++) {
		for (y=0; y <= interfaces_count; y++) {
			if (alarms[x].interface_id == interfaces[y].id) {
				// interfejs znaleziony
				if (!(interfaces[y].measured_value <= -100)) { // taka wartość wskazuje że jest coś nie tak z pomiarem, więc nie ma co na tym podstawie robić alertu
					if (alarms[x].direction == DIR_SMALLER) {
						if (interfaces[y].measured_value < alarms[x].action_level) {
							alarms[x].is_alarm = 1;
						} else {
							alarms[x].is_alarm = 0;
						}
					}
					if (alarms[x].direction == DIR_GREATER) {
						if (interfaces[y].measured_value > alarms[x].action_level) {
							alarms[x].is_alarm = 1;
						} else {
							alarms[x].is_alarm = 0;
						}
					}					
				}
			}
		}
	}

	
	for (x=0; x <= alarms_count; x++) {
		if (alarms[x].is_alarm == 1 && alarms[x].was_alarm == 0) { // jeśli to "świerzy" alarm, to go wrzuć do logów
			// ale nie wrzucaj za dużo i za często do logów
			if ((specials.seconds_since_midnight > alarms[x].last_notification + NOTIFICATION_INTERVAL) || (specials.seconds_since_midnight < alarms[x].last_notification)) {
				alarms[x].last_notification = specials.seconds_since_midnight;
				Log(alarms[x].text,alarms[x].alarm_level);
			}		
			
		}
		alarms[x].was_alarm = alarms[x].is_alarm;
	}
}
		
void ModAlarms_Debug() {	
	char buff[200];
	int x;
	const char *STATUS_OK = "\x1b[32m  OK   \x1b[0m";
	const char *STATUS_ALARM = "\x1b[31m ALARM \x1b[0m";
	
	Log("══════════════════════════ Zrzut alarmów ══════════════════════════",E_DEV);	
	Log("┌───────┬───────┬──────────────────────────────────────── Alarmy ──",E_DEV);
	Log("│Id     │Stan   │Tekst",E_DEV);
	Log("├───────┼───────┼──────────────────────────────────────────────────",E_DEV);				
	for(x = 0; x <= alarms_count; x++) {
		if (alarms[x].is_alarm == 0) { 
			sprintf(buff,"│%7i│%s│%.90s",alarms[x].id,STATUS_OK,alarms[x].text); 
		}
		if (alarms[x].is_alarm == 1) { 
			sprintf(buff,"│%7i│%s│%.90s",alarms[x].id,STATUS_ALARM,alarms[x].text); 
		}
		Log(buff,E_DEV);
	}					
	Log("└───────┴───────┴──────────────────────────────────────────────────",E_DEV);			
}

