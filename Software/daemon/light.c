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

struct _light {
	int pwm1;
	int pwm2;
	int t1;
	int t2;
	int tl;
	int pwm;
	int interface_id;
} light;

void ModLight_ReadSettings() {
	char buff[200];
	DB_GetSetting("light_pwm1",buff);
	light.pwm1 = atof(buff);
	DB_GetSetting("light_pwm2",buff);
	light.pwm2 = atof(buff);
	DB_GetSetting("light_t1",buff);
	light.t1 = atof(buff);
	DB_GetSetting("light_t2",buff);
	light.t2 = atof(buff);
	DB_GetSetting("light_tl",buff);
	light.tl = atof(buff);	
	DB_GetSetting("light_interface",buff);
	light.interface_id = atof(buff);	
	// wymuś stan nieustalony
	specials.is_night = -1;
}

void ModLight_Process() {
	//char buff[200];
	int y;
	if ((specials.seconds_since_midnight >= light.t1) && (specials.seconds_since_midnight < light.t2)) { // teraz jest dzień, więc sprawdzamy czy słońce wschodzi, czy zachodzi
		specials.night_ns = 0;
		if ((specials.seconds_since_midnight >= light.t1) && (specials.seconds_since_midnight < (light.t1 + light.tl))) { // wschód słońca
			light.pwm = light.pwm1 + (float)(specials.seconds_since_midnight - light.t1) / (float)light.tl * (light.pwm2 - light.pwm1);
		} else if ((specials.seconds_since_midnight >= (light.t2 - + light.tl)) && (specials.seconds_since_midnight < light.t2)) { //zachód słońca
			light.pwm = light.pwm1 + (float)(light.t2 - specials.seconds_since_midnight) / (float)light.tl * (light.pwm2 - light.pwm1);
		} else {
			light.pwm = light.pwm2;
		}
	} else {
		specials.night_ns = 1;
		light.pwm = 0; // w nocy PWM na zero
	}	
	// przypiszmy warotość PWM do interfejsu
	for (y=0; y <= interfaces_count; y++) {
		if (light.interface_id  == interfaces[y].id) {
			interfaces[y].new_state = light.pwm;
		}
	}	

	// zmiana trybu dzień - noc
	if (specials.night_ns != specials.is_night) {
		specials.is_night = specials.night_ns;
		if (specials.is_night == 0) {
			Log("Przechodzę w tryb dzień",E_INFO);
		} else {
			Log("Przechodzę w tryb noc",E_INFO);
		}
	}
}

void ModLight_Debug() { // informacje devel
	char buff[200];
	//struct tm* tm_info;
	Log("============ Zrzut danych modułu LIGHT ============",E_DEV);
	sprintf(buff,"T1: %i",light.t1);
	Log(buff,E_DEV);	
	sprintf(buff,"T2: %i",light.t2);
	Log(buff,E_DEV);	
	sprintf(buff,"TL: %i",light.tl);
	Log(buff,E_DEV);	
	sprintf(buff,"TA: %i",specials.seconds_since_midnight);
	Log(buff,E_DEV);	
	sprintf(buff,"PWM1: %3i%%",light.pwm1);
	Log(buff,E_DEV);
	sprintf(buff,"PWM2: %3i%%",light.pwm2);
	Log(buff,E_DEV);
	sprintf(buff,"PWM ACT: %3i%%",light.pwm);
	Log(buff,E_DEV);
	/*tm_info = gmtime((const time_t *)&light.tl);
	strftime(buff, 26, "TL:  %H:%M:%S", tm_info);
	Log(buff,E_DEV);	
	tm_info = gmtime((const time_t *)&light.t1);
	strftime(buff, 26, "T1:  %H:%M:%S", tm_info);
	Log(buff,E_DEV);
	tm_info = gmtime((const time_t *)&light.t2);
	strftime(buff, 26, "T2:  %H:%M:%S", tm_info);
	Log(buff,E_DEV);*/
	/*
	if ((specials.seconds_since_midnight >= light.t1) && (specials.seconds_since_midnight < light.t2)) {
		//specials.night_ns = 1;
		Log("Dzień",E_DEV);
	} else {
		Log("Noc",E_DEV);	
		//specials.night_ns = 0;
	}	*/
}