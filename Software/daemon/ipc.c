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
 * $Id$
 */
 
#include <unistd.h>
#include <stdio.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>

char *myfifo = "/tmp/aquapi.cmd";
char *myfifo2 = "/tmp/aquapi.res";
int fds[2];

char *XMLHead = "<?xml version=\"1.0\"?>\n"
				"<aquapi>\n";
char *XMLFoot = "</aquapi>\n";

void IPCCommandReload() {
	Log("Otrzymałem polecenie odświerzenia konfiguracji",E_INFO);
	ReadConf();
}

void IPCCommandAbout() {
	Log("Otrzymałem polecenie about",E_DEV);
	char buff[120];

	fds[1]=open(myfifo2,O_RDWR);

	sprintf(buff,"aquapi>about>beginning of reply.\n");
	write(fds[1],buff,strlen(buff));
	sprintf(buff,"aquapi>about>Hello, My name is AquaPi\n");
	write(fds[1],buff,strlen(buff));
	sprintf(buff,"aquapi>about>and I am aquarium computer daemon.\n");
	write(fds[1],buff,strlen(buff));
	sprintf(buff,"aquapi>about>PID:%i\n",getpid());
	write(fds[1],buff,strlen(buff));
	sprintf(buff,"aquapi>about>compilation: %s %s\n",build_date,build_time);
	write(fds[1],buff,strlen(buff));
	sprintf(buff,"aquapi>about>end of reply.\n");
	write(fds[1],buff,strlen(buff));
	close(fds[1]);	
}

void IPCCommandStatus() {
	Log("Otrzymałem polecenie status",E_DEV);
	char buff[400];
	int x;
	
	fds[1]=open(myfifo2,O_RDWR);

	write(fds[1],XMLHead,strlen(XMLHead));
	sprintf(buff,"<reply type=\"status\"/>\n");
	write(fds[1],buff,strlen(buff));	
	// przedstaw się ładnie
	sprintf(buff,"<daemon>\n");
	write(fds[1],buff,strlen(buff));
	sprintf(buff,"<pid>%i</pid>\n",getpid());
	write(fds[1],buff,strlen(buff));
	sprintf(buff,"<compilation_date>%s %s</compilation_date>\n",build_date,build_time);
	write(fds[1],buff,strlen(buff));
	sprintf(buff,"</daemon>\n");
	write(fds[1],buff,strlen(buff));
	// opowiedz co tam panie słychać w urządzonkach
	sprintf(buff,"<devices>\n");
	write(fds[1],buff,strlen(buff));

	for(x = 0; x <= interfaces_count; x++) {
		sprintf(buff,"<device id=\"%i\"><address>%s</address><name>%s</name><type>%i</type><state>%i</state><id>%i</id><measured_value>%f</measured_value></device>\n",interfaces[x].id,interfaces[x].address,interfaces[x].name,interfaces[x].type,interfaces[x].state,interfaces[x].id,interfaces[x].measured_value);
		write(fds[1],buff,strlen(buff));
	}	
	
	sprintf(buff,"</devices>\n");
	write(fds[1],buff,strlen(buff));
	write(fds[1],XMLFoot,strlen(XMLFoot));
	close(fds[1]);	
}

void InitIPC() {
	int flags,retval,i;
	char mode[] = "0777";
	
	mkfifo(myfifo,0777);
	mkfifo(myfifo2,0777);
	
	i = strtol(mode, 0, 8);
	chmod (myfifo,i);
	chmod (myfifo2,i);
	
	fds[0]=open(myfifo,O_RDWR);

	flags = fcntl( fds[0], F_GETFL,O_NONBLOCK);
	flags |= O_NONBLOCK;

	retval = fcntl( fds[0], F_SETFL, flags );
	if( retval == -1 ) {
		printf( "error setting flags\n" );
	}
}

void ProcessIPC() {
	char tab[BUFSIZ];
	tab[0] = 0;
	read(fds[0],tab,BUFSIZ);

	if (strncmp("aquapi:reload",tab,13)==0) {
		IPCCommandReload();
	} 
	if (strncmp("aquapi:about",tab,12)==0) {
		IPCCommandAbout();
	}
	if (strncmp("aquapi:status",tab,13)==0) {
		IPCCommandStatus();
	}
}

void CloseIPC() {
	close(fds[0]);

	unlink(myfifo);
	unlink(myfifo2);
}

