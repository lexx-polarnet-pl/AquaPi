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

#include <sys/socket.h>
#include <netinet/ip.h>
#include <pthread.h>
#include <errno.h>
#include <inttypes.h>
#include <arpa/inet.h>
#include <dirent.h>
#include <sys/utsname.h>
#include <sys/sysinfo.h>
#include "common.c"
#include <rb.h>
#define BUF_SIZE 255
#define QUERY_SIZE 1

char buf[BUF_SIZE];
FILE * net;
pthread_t id; // ID naszego wątku

char *XMLHead = "<?xml version=\"1.0\"?>\n"
				"<aquapi>\n";
char *XMLFoot = "</aquapi>\n";

void TCPCommandReload() {
	Log("Otrzymałem polecenie odświerzenia konfiguracji",E_INFO);
	ReadConf();
}

void TCPCommandUnknown() {
	char buff[120];
	Log("Otrzymałem nieznane polecenie przez TCP",E_INFO);
	sprintf(buff,"Command unknown.\n");
	fputs(buff,net);
	fflush(net);
	ReadConf();
}

void TCPCommandInterface(char *buf) {
	char buff[120];
	char *pcom;
	int interface,x,myint,nstate;
	Log("Otrzymałem polecenie interface",E_DEV);
	
	// numer interface jest od 17 bajtu
	interface=atoi(buf+17);

	// komenda jest za ostanim:
	pcom=strrchr(buf,':')+1;

	// szukamy co trzeba zmienić
	myint = 0;
	for(x = 0; x <= interfaces_count; x++) {
		if ((interfaces[x].type == DEV_OUTPUT) && (interfaces[x].id == interface)){
			myint = x;
		}		
	}
	// szukamy nowego stanu
	if (strncmp("on",pcom,2)==0) {
		nstate = 1;
	} else if (strncmp("off",pcom,3)==0) {
		nstate = 0;
	} else if (strncmp("auto",pcom,4)==0) {
		nstate = -1;
	} else {
		nstate = -2;
	}
	
	if (myint == 0 ) {
		fputs("Wrong interface number\n",net);
	} else if (nstate == -2) {
		fputs("Wrong subcommand\n",net);
	} else {
		if (nstate == -1) {
			sprintf(buff,"Tryb automatyczny dla %s",interfaces[myint].name);
		} else {
			sprintf(buff,"Tryb manualny dla %s",interfaces[myint].name);
		}
		Log(buff,E_INFO);
		interfaces[myint].override_value = nstate;
		specials.refresh_conf = 1;
		fputs("Executed.\n",net);
	}
	fflush(net);	
}

void TCPCommandAbout() {
	Log("Otrzymałem polecenie about",E_DEV);
	char buff[120];

	sprintf(buff,"aquapi>about>beginning of reply.\n");
	fputs(buff,net);
	sprintf(buff,"aquapi>about>Hello, My name is AquaPi\n");
	fputs(buff,net);
	sprintf(buff,"aquapi>about>and I am aquarium computer daemon.\n");
	fputs(buff,net);
	sprintf(buff,"aquapi>about>PID:%i\n",getpid());
	fputs(buff,net);
	sprintf(buff,"aquapi>about>compilation: %s %s\n",build_date,build_time);
	fputs(buff,net);
	sprintf(buff,"aquapi>about>end of reply.\n");
	fputs(buff,net);
	fflush(net);
}

void TCPCommandSysinfo() {
	struct utsname  uts;
	struct sysinfo  sys;
	time_t rawtime;

	uname(&uts);
	sysinfo(&sys);
	time(&rawtime);

	Log("Otrzymałem polecenie sysinfo",E_DEV);
	char buff[400];

	fputs(XMLHead,net);
	fputs("<reply type=\"sysinfo\"/>\n",net);
	fputs("<uname>\n",net);
	sprintf(buff,"<sysname>%s</sysname>\n",uts.sysname);
	fputs(buff,net);
	sprintf(buff,"<nodename>%s</nodename>\n",uts.nodename);
	fputs(buff,net);
	sprintf(buff,"<release>%s</release>\n",uts.release);
	fputs(buff,net);
	sprintf(buff,"<version>%s</version>\n",uts.version);
	fputs(buff,net);
	fputs("</uname>\n",net);

	fputs("<sysinfo>\n",net);
	sprintf(buff,"<load><av1m>%f</av1m><av5m>%f</av5m><av15m>%f</av15m></load>\n",sys.loads[0]/65536.0,sys.loads[1]/65536.0,sys.loads[2]/65536.0);
	fputs(buff,net);
	sprintf(buff,"<totalram>%llu</totalram>\n",sys.totalram *(unsigned long long)sys.mem_unit);
	fputs(buff,net);
	sprintf(buff,"<freeram>%llu</freeram>\n",sys.freeram *(unsigned long long)sys.mem_unit);
	fputs(buff,net);
	sprintf(buff,"<uptime>%lu</uptime>\n",sys.uptime);
	fputs(buff,net);
	sprintf(buff,"<procs>%d</procs>\n",sys.procs);
	fputs(buff,net);	
	fputs("</sysinfo>\n",net);

	fputs("<system>\n",net);
	sprintf(buff,"<rawtime>%ld</rawtime>\n", rawtime );
	fputs(buff,net);
	sprintf(buff,"<cpufreq>%f</cpufreq>\n",Get_Numeric_From_File("/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq")/1000);	
	fputs(buff,net);
	sprintf(buff,"<cputemp>%f</cputemp>\n",Get_Numeric_From_File("/sys/class/thermal/thermal_zone0/temp")/1000);
	fputs(buff,net);
	fputs("</system>\n",net);

	fputs(XMLFoot,net);
	fflush(net);
}

void TCPCommandStatus() {
	Log("Otrzymałem polecenie status",E_DEV);
	char buff[400];
	int x;

	fputs(XMLHead,net);
	sprintf(buff,"<reply type=\"status\"/>\n");
	fputs(buff,net);
	// przedstaw się ładnie
	sprintf(buff,"<daemon>\n");
	fputs(buff,net);
	sprintf(buff,"<pid>%i</pid>\n",getpid());
	fputs(buff,net);
	sprintf(buff,"<compilation_date>%s %s</compilation_date>\n",build_date,build_time);
	fputs(buff,net);
	sprintf(buff,"</daemon>\n");
	fputs(buff,net);
	// opowiedz co tam panie słychać w urządzonkach
	sprintf(buff,"<devices>\n");
	fputs(buff,net);

	for(x = 0; x <= interfaces_count; x++) {
		sprintf(buff,"<device id=\"%i\"><address>%s</address><name>%s</name><type>%i</type><state>%i</state><id>%i</id><measured_value>%f</measured_value><override_value>%i</override_value></device>\n",interfaces[x].id,interfaces[x].address,interfaces[x].name,interfaces[x].type,interfaces[x].state,interfaces[x].id,interfaces[x].measured_value,interfaces[x].override_value);
		fputs(buff,net);
	}

	sprintf(buff,"</devices>\n");
	fputs(buff,net);
	fputs(XMLFoot,net);
	fflush(net);
}

void TCPCommand1wList() {
	Log("Otrzymałem polecenie 1wlist",E_DEV);
	char buff[400];
	DIR * d;
	char * dir_name = "/sys/bus/w1/devices/";

	fputs(XMLHead,net);
	sprintf(buff,"<reply type=\"1wlist\"/>\n");
	fputs(buff,net);
	// przedstaw się ładnie
	sprintf(buff,"<daemon>\n");
	fputs(buff,net);
	sprintf(buff,"<pid>%i</pid>\n",getpid());
	fputs(buff,net);
	sprintf(buff,"<compilation_date>%s %s</compilation_date>\n",build_date,build_time);
	fputs(buff,net);
	sprintf(buff,"</daemon>\n");
	fputs(buff,net);
	// opowiedz co tam widać w 1-wire

	d = opendir (dir_name);
	if (! d) {
		sprintf(buff,"<reply status=\"error\"/>\n");
		fputs(buff,net);
		sprintf(buff,"<error id=%i>Nie umiem otworzyć katalogu '%s': %s</error>\n",errno,dir_name, strerror (errno));
		fputs(buff,net);
	} else {
		sprintf(buff,"<list>\n");
		fputs(buff,net);

		while (1) {
			struct dirent * entry;

			entry = readdir (d);
			if (! entry) {
				break;
			}
			if (!strncmp("28-",entry->d_name,3)) {
				// pokazujemy to co zaczyna się od 28-
				sprintf(buff,"\t<item>%s</item>\n",entry->d_name);
				fputs(buff,net);
			}
		}
		closedir(d);
		sprintf(buff,"</list>\n");
		fputs(buff,net);
	}
	fputs(XMLFoot,net);
	fflush(net);
}

void TCPCommandDeviceList() {
	Log("Otrzymałem polecenie devicelist",E_DEV);
	char buff[400];
	DIR * d;
	char * ds18b20_dir_name = "/sys/bus/w1/devices/";
	char * RelayBoard_dir_name = "/dev/";
	char device_path[50];	
	int x,piRev;
	
	fputs(XMLHead,net);
	fputs("<reply type=\"devicelist\"/>\n",net);
	// przedstaw się ładnie
	fputs("<daemon>\n",net);
	sprintf(buff,"<pid>%i</pid>\n",getpid());
	fputs(buff,net);
	sprintf(buff,"<compilation_date>%s %s</compilation_date>\n",build_date,build_time);
	fputs(buff,net);
	fputs("</daemon>\n",net);
	fputs("<devicelist>\n",net);
	
	// sprawdź czy jestem na Raspberry i jeśli jestem, opowiedz że mamy GPIO
	piRev = piBoardRev_noOops();
	if (piRev > 0) {
		for(x = 0; x <= 7; x++) {
			fputs("<device type=\"gpio\">\n",net);			
			sprintf(buff,"\t<address>%s%i</address>\n",PORT_RPI_GPIO_PREFIX,x);
			fputs(buff,net);
			fputs("\t<input>no</input>\n",net);
			fputs("\t<output>yes</output>\n",net);
			if (x == 1) { // tylko ten port obsługuj PWM (podobno)
				fputs("\t<pwm>yes</pwm>\n",net);
			}
			fputs("</device>\n",net);	
		}	
	}
	
	// opowiedz co tam widać z ds18b20
	d = opendir (ds18b20_dir_name);
	if (! d) {
		// nie można otworzyć katalogu
	} else {
		while (1) {
			struct dirent * entry;
			entry = readdir (d);
			if (! entry) {
				break;
			}
			// pokazujemy to co zaczyna się od 28-
			if (!strncmp("28-",entry->d_name,3)) {
				fputs("<device type=\"ds18b20\">\n",net);			
				sprintf(buff,"\t<address>%s%s</address>\n",INPUT_RPI_1W_PREFIX,entry->d_name);
				fputs(buff,net);
				fputs("\t<input>yes</input>\n",net);
				fputs("\t<output>no</output>\n",net);
				fputs("</device>\n",net);
			}
		}
		closedir(d);

	}
	
	// opowiedz co tam widać z RelayBoard
	d = opendir (RelayBoard_dir_name);
	if (! d) {
		// nie można otworzyć katalogu
	} else {
		while (1) {
			struct dirent * entry;
			entry = readdir (d);
			if (! entry) {
				break;
			}
			// pokazujemy to co zaczyna się od ttyUSB
			if (!strncmp("ttyUSB",entry->d_name,6)) {
				//sprawdź czy to jest RelayBoard
				sprintf (device_path,"/dev/%s",entry->d_name);
				if (!RelayBoardPortInit(device_path)) {
					for(x = 0; x <= 7; x++) {
						fputs("<device type=\"RelayBoard\">\n",net);			
						sprintf(buff,"\t<address>%s%s:%i</address>\n",PORT_RELBRD_PREFIX,entry->d_name,x);
						fputs(buff,net);
						fputs("\t<input>no</input>\n",net);
						fputs("\t<output>yes</output>\n",net);
						fputs("</device>\n",net);
					}
				}
			}
		}
		closedir(d);

	}

	// odpowiedz że mamy dummy outputs
	for(x = 1; x <= 10; x++) {
		fputs("<device type=\"dummy\">\n",net);			
		sprintf(buff,"\t<address>%s%i</address>\n",PORT_DUMMY_PREFIX,x);
		fputs(buff,net);
		fputs("\t<input>no</input>\n",net);
		fputs("\t<output>yes</output>\n",net);
		fputs("</device>\n",net);	
	}
	// odpowiedz że mamy dummy inputs
	for(x = 11; x <= 20; x++) {
		fputs("<device type=\"dummy\">\n",net);			
		sprintf(buff,"\t<address>%s%i</address>\n",INPUT_DUMMY_PREFIX,x);
		fputs(buff,net);
		fputs("\t<input>yes</input>\n",net);
		fputs("\t<output>no</output>\n",net);
		fputs("</device>\n",net);	
	}

	if (piRev > 0) {
		fputs("<device type=\"system_cpu_temp\">\n",net);			
		sprintf(buff,"\t<address>%s</address>\n",INPUT_SYSTEM_CPUTEMP);
		fputs(buff,net);
		fputs("\t<input>yes</input>\n",net);
		fputs("\t<output>no</output>\n",net);
		fputs("</device>\n",net);	
	}
	
	fputs("<device type=\"system_txtfile\">\n",net);			
	sprintf(buff,"\t<address>%s</address>\n",INPUT_SYSTEM_TXTFILE);
	fputs(buff,net);
	fputs("\t<input>yes</input>\n",net);
	fputs("\t<output>no</output>\n",net);
	fputs("\t<fully_editable_address>yes</fully_editable_address>\n",net);
	fputs("</device>\n",net);	
		
	fputs("</devicelist>\n",net);
	fputs(XMLFoot,net);
	fflush(net);
}

void* TCPConnections (void* unused) {
	char buff[200];
	// gniazdo ...
	int sh = socket(PF_INET, SOCK_STREAM, 0);
	if (sh<0) {
		sprintf(buff,"Błąd TCPIP: %s",strerror(errno));
		Log(buff,E_CRIT);
		exit(EXIT_FAILURE);
	}

	// utworzenie struktury opisującej adres
	struct sockaddr_in serwer;
	serwer.sin_family=AF_INET;
	serwer.sin_port=htons(config.bind_port);
	serwer.sin_addr.s_addr=inet_addr(config.bind_address);

	// przypisanie adresu ...
	if (bind(sh, (struct sockaddr *) &serwer, sizeof(struct sockaddr_in)) < 0) {
		sprintf(buff,"Błąd TCPIP: %s",strerror(errno));
		Log(buff,E_CRIT);
		exit(EXIT_FAILURE);
	}

	sprintf(buff,"Zaczynam nasłuchiwać na %s:%i",config.bind_address,config.bind_port);
	Log(buff,E_INFO);

	while(1) {
		// otwarcie portu do nasluchiwania
		if (listen(sh, QUERY_SIZE) < 0) {
			sprintf(buff,"Błąd TCPIP: %s",strerror(errno));
			Log(buff,E_CRIT);
			exit(EXIT_FAILURE);
		}

		// odebranie połączenia
		struct sockaddr_in from;
		socklen_t fromlen=sizeof(struct sockaddr_in);
		int sh2 = accept(sh, (struct sockaddr *) &from, &fromlen);
		// obsługa komend
		net=fdopen(sh2, "r+");
		while(fgets(buf, BUF_SIZE, net)) {
			if (strncmp("aquapi:reload",buf,13)==0) {
				TCPCommandReload();
				shutdown(sh2,SHUT_RDWR);
			} else if (strncmp("aquapi:about",buf,12)==0) {
				TCPCommandAbout();
				shutdown(sh2,SHUT_RDWR);
			} else if (strncmp("aquapi:status",buf,13)==0) {
				TCPCommandStatus();
				shutdown(sh2,SHUT_RDWR);
			} else if (strncmp("aquapi:1wlist",buf,13)==0) {
				TCPCommand1wList();
				shutdown(sh2,SHUT_RDWR);
			} else if (strncmp("aquapi:sysinfo",buf,14)==0) {
				TCPCommandSysinfo();
				shutdown(sh2,SHUT_RDWR);
			} else if (strncmp("aquapi:interface:",buf,17)==0) {
				TCPCommandInterface(buf);
				shutdown(sh2,SHUT_RDWR);
			} else if (strncmp("aquapi:devicelist",buf,17)==0) {
				TCPCommandDeviceList();
				shutdown(sh2,SHUT_RDWR);
			} else {
				TCPCommandUnknown();
				shutdown(sh2,SHUT_RDWR);
			}
		}
		fclose(net);
		close(sh2);
	}
	// zamkniecie gniazda
	close(sh);
}

int InitTCP () {
	// Tworzymy nowy wątek, nie przekazujemy atrybutów ani agrumentów funkcji.
	pthread_create (&id, NULL, &TCPConnections, NULL);
	return 0;
}
