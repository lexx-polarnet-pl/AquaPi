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
 
void ModTimers_ReadSettings() {
	MYSQL_RES *result;
	MYSQL_ROW row;

	// Wczytanie timerów
	Log("Wczytanie timerów",E_DEV);
	timers_count = 	-1;
	DB_Query("SELECT timer_id,timer_timeif,timer_action,timer_interfaceidthen,timer_days FROM timers ORDER BY timer_timeif ASC");
	result = mysql_store_result(conn);
	while ((row = mysql_fetch_row(result))) {
		timers_count++;
		timers[timers_count].id = atof(row[0]);
		if (row[1] != NULL) {
			timers[timers_count].timeif = atof(row[1]);
		}
		timers[timers_count].action = atof(row[2]);
		timers[timers_count].interfaceidthen = atof(row[3]);
		memcpy(timers[timers_count].days,row[4],sizeof(timers[timers_count].days));
	}	
	mysql_free_result(result);
}

void ModTimers_Process() {		
	int x,y;
	time_t rawtime;
	struct tm * timeinfo;
	
	time ( &rawtime );
	timeinfo = localtime ( &rawtime );
	
	// Dobra, spróbujmy przelecieć timery i określić jaki powinien być stan wyjść
	// przebieg 1 to dzień -1
	for (x=0; x <= timers_count; x++) {
		for (y=0; y <= interfaces_count; y++) {
			if (timers[x].interfaceidthen == interfaces[y].id) {
				interfaces[y].new_state = timers[x].action;
			}
		}
	}	
	// przebieg 2 to przebieg dla dnia bierzącego
	for (x=0; x <= timers_count; x++) {
		if (strncmp(timers[x].days+timeinfo->tm_wday,"1",1)  == 0) { // kontrola dnia tygodnia
			for (y=0; y <= interfaces_count; y++) {
				// teraz trzeba wziąść pod uwagę jeszcze czas
				if (timers[x].timeif <= specials.seconds_since_midnight) {
					if (timers[x].interfaceidthen == interfaces[y].id) {
						interfaces[y].new_state = timers[x].action;
					}
				}
			}
		}
	}	
}
		
void ModTimers_Debug() {	
	char buff[200];
	int x;
	
	Log("══════════════════════════ Zrzut timerów ══════════════════════════",E_DEV);	
	Log("┌───────┬───────┬───────┬───────┬───────┬──────────────── Timery ──",E_DEV);
	Log("│ID     │TimeIf │Action │Interf │Days   │",E_DEV);
	Log("├───────┼───────┼───────┼───────┼───────┤",E_DEV);				
	for(x = 0; x <= timers_count; x++) {
		sprintf(buff,"│%7i│%7i│%7i│%7i│%s│",timers[x].id,timers[x].timeif,timers[x].action,timers[x].interfaceidthen,timers[x].days);
		Log(buff,E_DEV);
	}					
	Log("└───────┴───────┴───────┴───────┴───────┘",E_DEV);					
}

