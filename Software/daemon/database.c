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
 
#include <my_global.h>
#include <mysql.h>

MYSQL *conn;
pthread_mutex_t mysql_mutex=PTHREAD_MUTEX_INITIALIZER;

int DB_Query(char *query);

void DB_Open(char *db_host, char *db_user, char *db_password, char *db_database) {
	char buff[200];
	conn = mysql_init(NULL);
	sprintf(buff,"Wersja klienta MySQL: %s", mysql_get_client_info());
	Log(buff,E_DEV);
	
	if (conn == NULL) {
		sprintf(buff,"Błąd SQL %u: %s", mysql_errno(conn), mysql_error(conn));
		Log(buff,E_SQL);
		termination_handler(1);
		exit(1);
	}
	if (mysql_real_connect(conn, db_host, db_user, db_password, db_database, 0, NULL, 0) == NULL) {
		sprintf(buff,"Błąd SQL %u: %s", mysql_errno(conn), mysql_error(conn));
		Log(buff,E_SQL);
		termination_handler(1);
		exit(1);
	}
	DB_Query("SET NAMES utf8");
}

void DB_Init() {
	DB_Open(config.db_host, config.db_user, config.db_password, config.db_database);
}

void DB_Close() {
	mysql_close(conn);
}

int DB_Query(char *query) {
	char buff[200];
	int res;
	pthread_mutex_lock(&mysql_mutex);
	res = mysql_query(conn, query);
	pthread_mutex_unlock(&mysql_mutex);
	if (res) {
		sprintf(buff,"Błąd zapytania \"%s\": %s",query,mysql_error(conn));
		Log(buff,E_SQL);
		//termination_handler(1);
		//exit(1);
	}
	return(res);
}

int DB_GetOne(char *query, char *value, int res_size) {
	MYSQL_RES *result;
	MYSQL_ROW row;
	char buff[200];
	//DB_Init();
	DB_Query(query);
	result = mysql_store_result(conn);
	row = mysql_fetch_row(result);
	if (row != NULL) {
		memcpy (value, row[0], res_size);
		mysql_free_result(result);
		return(0);
	} else {
		sprintf(buff,"Zapytanie SQL: %s zwróciło pusty wynik",query);
		Log(buff,E_SQL);
		return(1);
	}
	//DB_Close();
}

void DB_GetSetting(char *key, char *value) {
	char query[80];
	sprintf(query,"SELECT setting_value FROM settings WHERE `setting_key`='%s'",key);
	DB_GetOne(query,value,60);
}
