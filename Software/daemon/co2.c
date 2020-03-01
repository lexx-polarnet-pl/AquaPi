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
	double ph1;
	double mv1;
	double ph2;
	double mv2;
	double hysteresis;
	double a;
	double b;
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
	
	DB_GetSetting("co2_ph1",buff);
	co2.ph1 = atof(buff);	
	DB_GetSetting("co2_mv1",buff);
	co2.mv1 = atof(buff);	
	DB_GetSetting("co2_ph2",buff);
	co2.ph2 = atof(buff);	
	DB_GetSetting("co2_mv2",buff);
	co2.mv2 = atof(buff);	
	DB_GetSetting("co2_co2limit",buff);
	co2.co2limit = atof(buff);	
	DB_GetSetting("co2_o2limit",buff);
	co2.o2limit = atof(buff);	
	DB_GetSetting("co2_hysteresis",buff);
	co2.hysteresis = atof(buff);
	
	// wylicz współczynniki funkcji liniowej - a i b
	if (co2.ph1 == co2.ph2 || co2.mv1 == co2.mv2) {
		// jeśli ph1 = ph2 albo mv1 = mv2 to współczynników nie da się wyliczyć, więc przyjmujemy brak korekcji
		co2.a = 1;
		co2.b = 0;
	} else {
		co2.a = (co2.ph2-co2.ph1)/(co2.mv2-co2.mv1);
		co2.b = co2.ph1-co2.a*co2.mv1;
	}
}

void ModCo2_Process() {
	int x;
	double pH=7;
	// skoryguj wskazania sondy pH w oparciu o wyliczoną krzywą korekcji
	for(x = 0; x <= interfaces_count; x++) {
		if (interfaces[x].id == co2.phprobe_id) {
			 pH = co2.a * interfaces[x].raw_measured_value + co2.b;
			 interfaces[x].measured_value = pH;
		}
	}

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
	sprintf(buff,"pH CO2 limit: %.2f",co2.co2limit);
	Log(buff,E_DEV);	
	sprintf(buff,"pH O2 limit: %.2f",co2.o2limit);
	Log(buff,E_DEV);	
	sprintf(buff,"pH = %.2f * mV + %.2f",co2.a,co2.b);
	Log(buff,E_DEV);
	sprintf(buff,"Histereza: %.2f",co2.hysteresis);
	Log(buff,E_DEV);			
}