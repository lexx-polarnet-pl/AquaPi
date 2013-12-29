/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012-2013 AquaPi Developers
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

#define APPNAME "AquaPi"

char *build_date = __DATE__;  // data kompilacji
char *build_time = __TIME__;  // czas kompilacji

const char *PORT_RELBRD_PREFIX = "relbrd:";
const char *PORT_RPI_GPIO_PREFIX = "rpi:gpio:";
const char *PORT_DUMMY_PREFIX = "dummy:";

const int E_DEV  = -1;
const int E_INFO = 0;
const int E_WARN = 1;
const int E_CRIT = 2;
const int E_SQL  = 3;

const int DEV_OUTPUT = 2;

const int TRIGGER_TIME = 1;

void Log(char *msg, int lev);

void ReadConf();

void termination_handler(int signum);

struct _interfaces {
	int id;
	char address[30];
	char name[30];
	int type;
	int state;
	int new_state;
} interfaces[100];

int interfaces_count;

struct _timers {
	int type;
	int timeif;
	int action;
	int interfaceidthen;
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
	int temp_freq;
	int devel_freq;
	double dummy_temp_sensor_val;
} configuration;

configuration config;
