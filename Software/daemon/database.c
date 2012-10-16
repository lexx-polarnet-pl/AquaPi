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
 
//#include <stdio.h>
//#include <stdlib.h>
//#include <string.h>
//#include <unistd.h>
#include <sqlite3.h>

sqlite3 *db;
int rc;


int DB_Open() {
	//rc = sqlite3_open("/usr/share/aquapi/aquapi.db", &db);
	rc = sqlite3_open_v2("/usr/share/aquapi/aquapi.db", &db,1,0);
	if( rc ){
		fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
		sqlite3_close(db);
		return 1;
	} else {
		//printf("Baza otwarta\n");
		return 0;
	}
}

void DB_Close() {
	sqlite3_close(db);
}

void DB_GetSetting(char *key, char *value) {
	//int s;
	const unsigned char * text;
	sqlite3_stmt * stmt;
	char query[80]= "select value from settings where key='";
	strcat(query, key);
	strcat(query, "';");

	sqlite3_prepare_v2 (db, query, strlen (query) + 1, & stmt, NULL);
	sqlite3_step (stmt);
	text  = sqlite3_column_text (stmt, 0);
	//printf ("%s\n",  text);	
	memcpy (value, text, 60);
}
