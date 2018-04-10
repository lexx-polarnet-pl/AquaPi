/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012-2018 AquaPi Developers
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

struct _temperature {
	double  tmax;
	double  hc;
	double  tmin;
	double  hg;
	double  ncor;
	double  tmaxal;	
	double  tminal;
	double  actual;
	int interface_heat;
	int interface_cool;
	int interface_sensor;	
	int is_in_alarm_mode;
} temperature;

void ModTemperature_ReadSettings() {
	char buff[200];
	DB_GetSetting("temp_tmax",buff);
	temperature.tmax = atof(buff);
	DB_GetSetting("temp_hc",buff);
	temperature.hc = atof(buff);	
	DB_GetSetting("temp_tmin",buff);
	temperature.tmin = atof(buff);	
	DB_GetSetting("temp_hg",buff);
	temperature.hg = atof(buff);	
	DB_GetSetting("temp_ncor",buff);
	temperature.ncor = atof(buff);	
	DB_GetSetting("temp_tmaxal",buff);
	temperature.tmaxal = atof(buff);	
	DB_GetSetting("temp_tminal",buff);
	temperature.tminal = atof(buff);	
	DB_GetSetting("temp_tmax",buff);
	temperature.tmax = atof(buff);

	DB_GetSetting("temp_interface_heat",buff);
	temperature.interface_heat = atof(buff);	
	DB_GetSetting("temp_interface_cool",buff);
	temperature.interface_cool = atof(buff);	
	DB_GetSetting("temp_interface_sensor",buff);
	temperature.interface_sensor = atof(buff);	
	// wymuś stan nieustalony
	temperature.actual = -100;
	// nie ma alarmu
	temperature.is_in_alarm_mode = 0;
}

void ModTemperature_Process() {

	//Odczytajmy aktualną temperaturę
	temperature.actual = GetValFromInterface(temperature.interface_sensor);

	//Czy włączamy grzanie?
	if (temperature.actual < temperature.tmin) {
		SetInterfaceNewVal(temperature.interface_heat,1);
	}
	//Czy wyłączamy grzanie?
	if (temperature.actual > temperature.tmin + temperature.hg) {
		SetInterfaceNewVal(temperature.interface_heat,0);
	}
	//Czy włączamy chłodzenie?
	if (temperature.actual > temperature.tmax) {
		SetInterfaceNewVal(temperature.interface_cool,1);
	}
	//Czy wyłączamy chłodzenie?
	if (temperature.actual < temperature.tmax - temperature.hc) {
		SetInterfaceNewVal(temperature.interface_cool,0);
	}
	//Wyczyść flagę alarmu jak jest ok
	if (temperature.actual > temperature.tminal && temperature.actual < temperature.tmaxal) {
		temperature.is_in_alarm_mode = 0;
	} else if (temperature.actual <= temperature.tminal && temperature.is_in_alarm_mode == 0) {
		temperature.is_in_alarm_mode = 1;
		Log("Temperatura mierzona przekroczyła próg alarmowy dla wartości minimalnej",E_WARN);	
	} else if (temperature.actual >= temperature.tmaxal && temperature.is_in_alarm_mode == 0) {
		temperature.is_in_alarm_mode = 1;
		Log("Temperatura mierzona przekroczyła próg alarmowy dla wartości maksymalnej",E_WARN);			
	}
}

void ModTemperature_Debug() { // informacje devel
	char buff[200];
	Log("============ Zrzut danych modułu TEMPERATURE ============",E_DEV);
	sprintf(buff,"Tact %.1f°C, Tminal: %.1f°C, Tmin: %.1f°C, Hg: %.1f°C, Hc: %.1f°C, Tmax: %.1f°C, Tmaxal: %.1f°C, Tncor: %.1f°C", \
		temperature.actual,temperature.tminal,temperature.tmin,temperature.hg,temperature.hc,temperature.tmax,temperature.tmaxal,temperature.ncor);
	Log(buff,E_DEV);	
}