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

#define APPNAME "AquaPi"

const int E_DEV = -1;
const int E_INFO = 0;
const int E_WARN = 1;
const int E_CRIT = 2;

void Log(char *msg, int lev);

void ReadConf();

void termination_handler(int signum);

int events_count,outputs_count;

struct _events {
	int start,stop,enabled,day_of_week;
	char device[10];
} events[500]; 

//struct _sensors {
//	int sensor_id;
//	char sensor_address[20], sensor_corr[10];
//} sensors[500]; 


struct _outputs {
	int enabled,new_state;
	//char *name;
	char name[40];
	char output_port[10];
	char device[10];
} outputs[40];

typedef struct
{
    char* db_host;
    char* db_user; 
	char* db_password;
	char* db_database;
	int dontfork;
	double dummy_temp_sensor_val;
} configuration;

configuration config;
