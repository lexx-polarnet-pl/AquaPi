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

#define APPNAME "AquaPi"

const char *build_date = __DATE__;  // data kompilacji
const char *build_time = __TIME__;  // czas kompilacji

//prefiksy portów wej/wyj
const char *PORT_RELBRD_PREFIX = "relbrd:"; // to jest do usunięcia - brak wsparcia
const char *PORT_RPI_GPIO_PREFIX = "rpi:gpio:";
const char *PORT_RPI_1W_PREFIX = "rpi:1w:";
const char *PORT_RPI_I2C_MINIPH_PREFIX = "rpi:i2c:miniph:";
const char *PORT_DUMMY_PREFIX = "dummy:";
const char *PORT_TEXT_FILE_PREFIX = "rpi:system:txtfile:";

//prefiksy portów wejściowych
const char *INPUT_RPI_1W_PREFIX = "rpi:1w:";
const char *INPUT_DUMMY_PREFIX = "dummy:";
const char *INPUT_RPI_I2C_MINIPH_PREFIX = "rpi:i2c:miniph";

//sensory systemowe
//const char *INPUT_SYSTEM_CPUTEMP = "rpi:system:cputemp";
//const char *INPUT_SYSTEM_TXTFILE = "rpi:system:txtfile";

const int E_DEV  = -1;
const int E_INFO = 0;
const int E_WARN = 1;
const int E_CRIT = 2;
const int E_SQL  = 3;

// typ urządzenia
const int DEV_INPUT = 1;
const int DEV_OUTPUT = 2;
const int DEV_OUTPUT_PWM = 3;

void Log(char *msg, int lev);

void ReadConf();

void termination_handler(int signum);

void ProcessPortStates();

struct _interfaces {
	int id;
	char address[128];
	char name[30];
	int type;
	int state;
	int new_state;
	int draw;
	double measured_value;
	double raw_measured_value;
	int override_value;
	int override_expire;
	int was_error_last_time;
	int service_val;
	int dashboard;
	double conf;
} interfaces[100];

int interfaces_count;

struct _timers {
	int id;
	int timeif;
	int action;
	int interfaceidthen;
	char days[7]; 
} timers[100];

int timers_count;	

typedef struct
{
	char* db_host;
	char* db_user; 
	char* db_password;
	char* db_database;
	int dontfork;
	int stat_freq;
	int inputs_freq;
	int devel_freq;
	int reload_freq;
	int bind_port;
	char* bind_address;
} configuration;

configuration config;

struct _specials {
	int is_night;
	int is_service_mode;
	int service_mode_input;
	int night_ns;
	int seconds_since_midnight;
	int last_sec_run;
	int last_sec_store_stat;
} specials;

struct I2CDEV {
	int fd;
	int state;
};

struct _hardware {
	int RaspiBoardVer;
	struct I2CDEV i2c_PCF8574[4];
	struct I2CDEV i2c_ADS1115[4];
	struct I2CDEV i2c_MinipH;
} hardware;


// stałe związane z i2c
const int PCF8574_BASE_ADDR = 0x20;	// od tego adresu i2c zaczynamy szukać PCF8574
const int PCF8574_BASE_PIN = 64;	// od tego numeru zaczynamy rejestrować piny w WiringPi
const int ADS1115_BASE_ADDR = 0x48; // od tego adresu i2c zaczynamy szukać ADS1115
const int ADS1115_BASE_PIN = 128;	// od tego numeru zaczynamy rejestrować piny w WiringPi 
const int MINIPH_ADDR = 0x4D;