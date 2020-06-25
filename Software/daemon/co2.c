/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012-2019 AquaPi Developers
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

struct _co2 {
	int phprobe_id;
	int co2valve_id;
	int o2valve_id;
	double hysteresis;
	double co2limit;
	double o2limit;
} co2;

void ModCo2_ReadSettings() {
	char buff[200];
	DB_GetSetting("co2_probe",buff);
	co2.phprobe_id = atof(buff);
	DB_GetSetting("co2_co2valve",buff);
	co2.co2valve_id = atof(buff);
	DB_GetSetting("co2_o2valve",buff);
	co2.o2valve_id = atof(buff);	
	
	DB_GetSetting("co2_co2limit",buff);
	co2.co2limit = atof(buff);	
	DB_GetSetting("co2_o2limit",buff);
	co2.o2limit = atof(buff);	
	DB_GetSetting("co2_hysteresis",buff);
	co2.hysteresis = atof(buff);
}

void ModCo2_Process() {
	double pH=7;

	pH = GetValFromInterface(co2.phprobe_id);
	
	// jeśli ph powyżej limitu załączania co2, to je odpalamy 
	if (pH > (co2.co2limit + co2.hysteresis/2)) {
		SetInterfaceNewVal(co2.co2valve_id,1);		
	} 

	// jeśli ph poniżej limitu załączania co2, to wyłączamy
	if (pH < (co2.co2limit - co2.hysteresis/2)) {
		SetInterfaceNewVal(co2.co2valve_id,0);		
	} 	

	// jak jest noc, to CO2 ma być wyłączone
	if (specials.is_night == 1) {
		SetInterfaceNewVal(co2.co2valve_id,0);				
	}

	// jeśli ph poniżej limitu załączania o2, to odpalamy napowietrzacz 
	if (pH < (co2.o2limit - co2.hysteresis/2)) {
		SetInterfaceNewVal(co2.o2valve_id,1);	
	}

	// jeśli ph wzrośnie to napowietrzacz wyłączamy
	if (pH > (co2.o2limit + co2.hysteresis/2)) {
		SetInterfaceNewVal(co2.o2valve_id,0);	
	}

	// zabezpieczenie na wypadek awarii sondy pH
	if (pH <= 0) {
		SetInterfaceNewVal(co2.co2valve_id,0);
		SetInterfaceNewVal(co2.o2valve_id,0);
	}
}

void ModCo2_Debug() { // informacje devel
	char buff[200];
	Log("════════════════════════ Zrzut danych CO2 ═════════════════════════",E_DEV);		
	sprintf(buff,"pH: %.2f",GetValFromInterface(co2.phprobe_id));
	Log(buff,E_DEV);	
	sprintf(buff,"pH CO2 limit: %.2f",co2.co2limit);
	Log(buff,E_DEV);	
	sprintf(buff,"pH O2 limit: %.2f",co2.o2limit);
	Log(buff,E_DEV);	
	sprintf(buff,"Histereza: %.2f",co2.hysteresis);
	Log(buff,E_DEV);			
}