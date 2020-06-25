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

#include <stdbool.h>

struct _calib_data {
	int id;
	int interface_id;
	double data_raw1;
	double data_cal1;
	double data_raw2;
	double data_cal2;
	double a;
	double b;

} calib_data[100];

int calib_data_count;	
 
void Calibration_ReadSettings() {
	MYSQL_RES *result;
	MYSQL_ROW row;

	// Wczytanie danych kalibracyjnych
	Log("Wczytanie danych kalibracyjnych",E_DEV);
	calib_data_count = 	-1;
	DB_Query("SELECT calib_data_id,calib_data_interface_id,calib_data_raw1,calib_data_cal1,calib_data_raw2,calib_data_cal2 FROM calib_data");
	result = mysql_store_result(conn);
	while ((row = mysql_fetch_row(result))) {
		calib_data_count++;
		calib_data[calib_data_count].id = atof(row[0]);
		calib_data[calib_data_count].interface_id = atof(row[1]);
		calib_data[calib_data_count].data_raw1 = atof(row[2]);
		calib_data[calib_data_count].data_cal1 = atof(row[3]);
		calib_data[calib_data_count].data_raw2 = atof(row[4]);
		calib_data[calib_data_count].data_cal2 = atof(row[5]);
		// wylicz współczynniki funkcji liniowej - a i b
		if (calib_data[calib_data_count].data_raw1 == calib_data[calib_data_count].data_raw2 || calib_data[calib_data_count].data_cal1 == calib_data[calib_data_count].data_cal2) {
			// jeśli raw1 = raw2 albo cal1 = cal2 to współczynników nie da się wyliczyć, więc przyjmujemy brak korekcji
			calib_data[calib_data_count].a = 1;
			calib_data[calib_data_count].b = 0;
		} else {
			calib_data[calib_data_count].a = (calib_data[calib_data_count].data_cal2-calib_data[calib_data_count].data_cal1)/(calib_data[calib_data_count].data_raw2-calib_data[calib_data_count].data_raw1);
			calib_data[calib_data_count].b = calib_data[calib_data_count].data_cal1-calib_data[calib_data_count].a*calib_data[calib_data_count].data_raw1;
		}			
	}	
	mysql_free_result(result);
}

void Calibration_Process() {		
	int x,y,calibrated;
	
	// przejedźmy się po interfejsach, i ew. dokonaj na nich korekcji
	for (y=0; y <= interfaces_count; y++) {
		calibrated = false;
		for (x=0; x <= calib_data_count; x++) {
			if (calib_data[x].interface_id == interfaces[y].id) {
				interfaces[y].measured_value = calib_data[x].a * interfaces[y].raw_measured_value + calib_data[x].b;
				calibrated = true;
			}
		}
		if (!calibrated) {
			interfaces[y].measured_value = interfaces[y].raw_measured_value;
		}
	}
}
	
void Calibration_Debug() {	
	char buff[200];
	int x;
	
	Log("═════════════════════ Zrzut danych kalibracyjnych ═════════════════",E_DEV);	
	Log("┌─────┬───────┬───────┬───────┬───────┬───────┬──────────── Dane ──",E_DEV);
	Log("│Id   │Interf.│Raw1   │Cal1   │Raw2   │Cal2   │A      │B      │",E_DEV);
	Log("├─────┼───────┼───────┼───────┼───────┼───────┼───────┼───────┤",E_DEV);				
	for(x = 0; x <= calib_data_count; x++) {
		sprintf(buff,"│%5i│%7i│%7.2f│%7.2f│%7.2f│%7.2f│%7.2f│%7.2f│",calib_data[x].id,calib_data[x].interface_id,calib_data[x].data_raw1,calib_data[x].data_cal1,calib_data[x].data_raw2,calib_data[x].data_cal2,calib_data[x].a,calib_data[x].b); 
		Log(buff,E_DEV);
	}
	Log("└─────┴───────┴───────┴───────┴───────┴───────┴───────┴───────┘",E_DEV);
}

