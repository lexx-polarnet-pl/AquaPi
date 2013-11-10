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
 * $Id$
 */
 
#include <my_global.h>
#include <mysql.h>

MYSQL *conn;

void DB_Query(char *query);

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
	DB_Query("SET NAMES utf8;");
}

void DB_Close() {
	mysql_close(conn);
}

void DB_Query(char *query) {
	mysql_query(conn, query);
}

void DB_GetSetting(char *key, char *value) {
	char query[80];
	MYSQL_RES *result;
	MYSQL_ROW row;
	
	sprintf(query,"select value from settings where `key`='%s';",key);
	mysql_query(conn, query);
	result = mysql_store_result(conn);
	row = mysql_fetch_row(result);
	memcpy (value, row[0], 60);
	mysql_free_result(result);
}

void DB_GetOne(char *query, char *value, int res_size) {
	MYSQL_RES *result;
	MYSQL_ROW row;
	
	mysql_query(conn, query);
	result = mysql_store_result(conn);
	row = mysql_fetch_row(result);
	//memcpy (value, row[0], sizeof(**value));
	memcpy (value, row[0], res_size);
	mysql_free_result(result);
}
