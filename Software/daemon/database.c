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
 
#include <my_global.h>
#include <mysql.h>

MYSQL *conn;

int DB_Query(char *query);

void DB_Open(char *db_host, char *db_user, char *db_password, char *db_database) {
	conn = mysql_init(NULL);

	if (conn == NULL) {
		fprintf(stderr,"Error %u: %s\n", mysql_errno(conn), mysql_error(conn));
		exit(1);
	}

	if (mysql_real_connect(conn, db_host, db_user, db_password, db_database, 0, NULL, 0) == NULL) {
		fprintf(stderr,"Error %u: %s\n", mysql_errno(conn), mysql_error(conn));
		exit(1);
	}
	DB_Query("SET NAMES utf8");
}

void DB_Close() {
	mysql_close(conn);
}

int DB_Query(char *query) {
	return mysql_query(conn, query);
}


int DB_GetOne(char *query, char *value, int res_size) {
	MYSQL_RES *result;
	MYSQL_ROW row;
	char buff[200];
	if (DB_Query(query)) {
		sprintf(buff,"Błąd SQL: %s",mysql_error(conn));
		Log(buff,E_SQL);
		exit(1);
	} else {
		result = mysql_store_result(conn);
		row = mysql_fetch_row(result);
		if (row != NULL) {
			//memcpy (value, row[0], sizeof(**value));
			memcpy (value, row[0], res_size);
			mysql_free_result(result);
			return(0);
		} else {
			sprintf(buff,"Zapytanie SQL: %s zwróciło pusty wynik",query);
			Log(buff,E_SQL);
			return(1);
		}
	}
}

void DB_GetSetting(char *key, char *value) {
	char query[80];
	sprintf(query,"SELECT setting_value FROM settings WHERE `setting_key`='%s'",key);
	DB_GetOne(query,value,60);
}
