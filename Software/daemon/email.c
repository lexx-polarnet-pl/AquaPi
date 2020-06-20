/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012-2020 AquaPi Developers
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

const char *email_template = "<!doctype html>\
<html lang='pl'>\
<head>\
	<meta charset='utf-8'>\
	<link href='https://fonts.googleapis.com/css2?family=Montserrat&display=swap' rel='stylesheet'>   \
	<style>\
	body {font-family: 'Montserrat', sans-serif;}\
	.header {background-color: red; text-align:center; color:white; font-size:20pt; padding:1pt;}\
	</style>\
</head>\
<body>\
	<div class='header'>\
		<h1>⚠️</h1>\
		<p>%s</p>\
	</div>\
</body>\
</html>";

const char *email_command = "mail -s 'AquaPi' -a 'MIME-Version: 1.0' -a 'Content-type: text/html; charset=utf-8' -r 'AquaPi <aquapi@noreply>' %s < /tmp/errormail";

char email_address[200];

void email_ReadSettings() {
	DB_GetSetting("email_address",email_address);
}

void email_error(char *msg, int lev) {
	FILE *fp;
	char command[200];
	
	fp = fopen("/tmp/errormail", "w+");
    fprintf(fp, email_template,msg);
    fclose(fp);
	
	sprintf(command,email_command,email_address);
	system(command);
	
	remove("/tmp/errormail");
}

