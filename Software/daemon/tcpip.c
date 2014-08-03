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
#include <libxml/parser.h>
#include "common.c"
#include <rb.h>
#define BUF_SIZE 255
#define QUERY_SIZE 1

char buf[BUF_SIZE];
FILE * net;
pthread_t id; // ID naszego wątku

// zmienne do obsługi XMLa
xmlNodePtr xml_root_node;
xmlDocPtr xml_doc;
xmlChar *xml_buff;

void XMLCreateReply(char *reply_type) {
	xmlNodePtr node;

	// Tworzymy nowego XMLa
    xml_doc = xmlNewDoc(BAD_CAST "1.0");
    xml_root_node = xmlNewNode(NULL, BAD_CAST "aquapi");
    xmlDocSetRootElement(xml_doc, xml_root_node);

	// typ odpowiedzi
	node = xmlNewChild(xml_root_node, NULL, BAD_CAST "reply", NULL);
	xmlNewProp(node, BAD_CAST "type", BAD_CAST reply_type);
}

void XMLSendReply() {
	int xml_buffersize;
	
	// wyślij 
	xmlDocDumpFormatMemory(xml_doc, &xml_buff, &xml_buffersize, 1);
	fputs( (char *) xml_buff,net);
	fflush(net);
	// posprzątaj
    xmlFree(xml_buff);
    xmlFreeDoc(xml_doc);
}

void XMLCreateDaemonEntry() {
	xmlNodePtr node;
	char buff[120];
	// przedstaw się ładnie
	node = xmlNewChild(xml_root_node, NULL, BAD_CAST "daemon", NULL);
	sprintf(buff, "%i", getpid());	
	xmlNewChild(node, NULL, BAD_CAST "pid", BAD_CAST buff);
	sprintf(buff, "%s %s", build_date,build_time);	
	xmlNewChild(node, NULL, BAD_CAST "compilation_date", BAD_CAST buff);
}


void XMLCreateDeviceEntry(xmlNodePtr master_node, char *type, const char *address, char *input, char *output, char *pwm, char *description, char *fea, char *prompt) {
	xmlNodePtr node;
	
	node = xmlNewChild(master_node, NULL, BAD_CAST "device", NULL);
	xmlNewProp(node, BAD_CAST "type", BAD_CAST type);		
	xmlNewChild(node, NULL, BAD_CAST "address", BAD_CAST address);
	xmlNewChild(node, NULL, BAD_CAST "input", BAD_CAST input);
	xmlNewChild(node, NULL, BAD_CAST "output", BAD_CAST output);
	xmlNewChild(node, NULL, BAD_CAST "pwm", BAD_CAST pwm);
	xmlNewChild(node, NULL, BAD_CAST "description", BAD_CAST description);
	
	if (fea != NULL) {
		xmlNewChild(node, NULL, BAD_CAST "fully_editable_address", BAD_CAST fea);
		xmlNewChild(node, NULL, BAD_CAST "prompt", BAD_CAST prompt);
	}
}

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
		ProcessPortStates();
		fputs("Executed.\n",net);
	}
	fflush(net);	
}

void TCPCommandAbout() {
	Log("Otrzymałem polecenie about",E_DEV);
	XMLCreateReply("about");
	xmlNewChild(xml_root_node, NULL, BAD_CAST "about", BAD_CAST "Hello, My name is AquaPi and I am aquarium computer daemon.");
	XMLSendReply();	
}

void TCPCommandSysinfo() {
	struct utsname  uts;
	struct sysinfo  sys;
	time_t rawtime;
	xmlNodePtr node,node2;
	
	uname(&uts);
	sysinfo(&sys);
	time(&rawtime);

	Log("Otrzymałem polecenie sysinfo",E_DEV);
	char buff[400];

	XMLCreateReply("sysinfo");
	
	// uname
	node = xmlNewChild(xml_root_node, NULL, BAD_CAST "uname", NULL);
	xmlNewChild(node, NULL, BAD_CAST "sysname", BAD_CAST uts.sysname);
	xmlNewChild(node, NULL, BAD_CAST "nodename", BAD_CAST uts.nodename);
	xmlNewChild(node, NULL, BAD_CAST "release", BAD_CAST uts.release);
	xmlNewChild(node, NULL, BAD_CAST "version", BAD_CAST uts.version);

	// sysinfo
	node = xmlNewChild(xml_root_node, NULL, BAD_CAST "sysinfo", NULL);
	node2 = xmlNewChild(node, NULL, BAD_CAST "load", NULL);
	sprintf(buff, "%f", sys.loads[0]/65536.0);
	xmlNewChild(node2, NULL, BAD_CAST "av1m", BAD_CAST buff);
	sprintf(buff, "%f", sys.loads[1]/65536.0);
	xmlNewChild(node2, NULL, BAD_CAST "av5m", BAD_CAST buff);
	sprintf(buff, "%f", sys.loads[2]/65536.0);
	xmlNewChild(node2, NULL, BAD_CAST "av15m", BAD_CAST buff);
	sprintf(buff, "%llu", sys.totalram *(unsigned long long)sys.mem_unit);
	xmlNewChild(node, NULL, BAD_CAST "totalram", BAD_CAST buff);
	sprintf(buff, "%llu", sys.freeram *(unsigned long long)sys.mem_unit);
	xmlNewChild(node, NULL, BAD_CAST "freeram", BAD_CAST buff);
	sprintf(buff, "%lu", sys.uptime);
	xmlNewChild(node, NULL, BAD_CAST "uptime", BAD_CAST buff);
	sprintf(buff, "%d", sys.procs);
	xmlNewChild(node, NULL, BAD_CAST "procs", BAD_CAST buff);
	
	// system
	node = xmlNewChild(xml_root_node, NULL, BAD_CAST "system", NULL);
	sprintf(buff, "%ld", rawtime );
	xmlNewChild(node, NULL, BAD_CAST "rawtime", BAD_CAST buff);
	sprintf(buff, "%f", Get_Numeric_From_File("/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq")/1000);
	xmlNewChild(node, NULL, BAD_CAST "cpufreq", BAD_CAST buff);
	sprintf(buff, "%f", Get_Numeric_From_File("/sys/class/thermal/thermal_zone0/temp")/1000);
	xmlNewChild(node, NULL, BAD_CAST "cputemp", BAD_CAST buff);

	XMLSendReply();
}

void TCPCommandStatus() {
	Log("Otrzymałem polecenie status",E_DEV);
	char buff[400];
	int x;
	xmlNodePtr node,node2;
	
	XMLCreateReply("status");
	
	XMLCreateDaemonEntry();
	
	// opowiedz co tam panie słychać w urządzonkach
	node = xmlNewChild(xml_root_node, NULL, BAD_CAST "devices", NULL);

	for(x = 0; x <= interfaces_count; x++) {
		node2 = xmlNewChild(node, NULL, BAD_CAST "device", NULL);
		sprintf(buff, "%i", interfaces[x].id);
		xmlNewProp(node2, BAD_CAST "id", BAD_CAST buff);	
		xmlNewChild(node2, NULL, BAD_CAST "id", BAD_CAST buff);
		xmlNewChild(node2, NULL, BAD_CAST "address", BAD_CAST interfaces[x].address);
		xmlNewChild(node2, NULL, BAD_CAST "name", BAD_CAST interfaces[x].name);
		sprintf(buff, "%i", interfaces[x].type);
		xmlNewChild(node2, NULL, BAD_CAST "type", BAD_CAST buff);
		sprintf(buff, "%i", interfaces[x].state);
		xmlNewChild(node2, NULL, BAD_CAST "state", BAD_CAST buff);
		sprintf(buff, "%f", interfaces[x].measured_value);
		xmlNewChild(node2, NULL, BAD_CAST "measured_value", BAD_CAST buff);
		sprintf(buff, "%i", interfaces[x].override_value);
		xmlNewChild(node2, NULL, BAD_CAST "override_value", BAD_CAST buff);		
	}
	
	XMLSendReply();	
}

void TCPCommand1wList() {
	Log("Otrzymałem polecenie 1wlist",E_DEV);
	char buff[400];
	DIR * d;
	char * dir_name = "/sys/bus/w1/devices/";
	xmlNodePtr node,node2;
	
	XMLCreateReply("1wlist");
	XMLCreateDaemonEntry();
	
	// opowiedz co tam widać w 1-wire

	d = opendir (dir_name);
	if (! d) {
		node = xmlNewChild(xml_root_node, NULL, BAD_CAST "reply", NULL);
		xmlNewProp(node, BAD_CAST "status", BAD_CAST "error");
		sprintf(buff,"Nie umiem otworzyć katalogu '%s': %s",dir_name, strerror (errno));
		node2 = xmlNewChild(node, NULL, BAD_CAST "error", BAD_CAST buff);
		sprintf(buff,"%i",errno);
		xmlNewProp(node2, BAD_CAST "id", BAD_CAST buff);
	} else {
		node = xmlNewChild(xml_root_node, NULL, BAD_CAST "list", NULL);

		while (1) {
			struct dirent * entry;

			entry = readdir (d);
			if (! entry) {
				break;
			}
			if (!strncmp("28-",entry->d_name,3)) {
				// pokazujemy to co zaczyna się od 28-
				xmlNewChild(node, NULL, BAD_CAST "item", BAD_CAST entry->d_name);
			}
		}
		closedir(d);
	}
	XMLSendReply();	
}

void TCPCommandDeviceList() {
	char address[200];
	char description[400];
	DIR * d;
	char * ds18b20_dir_name = "/sys/bus/w1/devices/";
	char * RelayBoard_dir_name = "/dev/";
	char device_path[50];	
	int x,i;
	xmlNodePtr node;

	Log("Otrzymałem polecenie devicelist",E_DEV);	
	XMLCreateReply("devicelist");
	XMLCreateDaemonEntry();

	node = xmlNewChild(xml_root_node, NULL, BAD_CAST "devicelist", NULL);
	
	// sprawdź czy jestem na Raspberry i jeśli jestem, opowiedz że mamy GPIO
	if (hardware.RaspiBoardVer > 0) {
		for(x = 0; x <= 6; x++) {
			sprintf(address, "%s%i", PORT_RPI_GPIO_PREFIX,x);
			sprintf(description, "Pin GPIO numer %i", x);
			if (x == 1) { // tylko ten port obsługuj PWM (podobno)
				XMLCreateDeviceEntry(node,"gpio",address,"yes","yes","yes",description, NULL, NULL);
			} else {
				XMLCreateDeviceEntry(node,"gpio",address,"yes","yes","no",description, NULL, NULL);
			}
		}	
		// sprawdź też i2c
		for (i = 0; i < 4; i++) {
			if (hardware.i2c_PCF8574[i].state != -1) {
				for(x = 0; x <= 7; x++) {
					sprintf(address,"%s%i",PORT_RPI_GPIO_PREFIX,PCF8574_BASE_PIN+i*8+x);
					sprintf(description,"PCF8574 adres %#x, pin numer %in",PCF8574_BASE_ADDR+i,x);
					XMLCreateDeviceEntry(node,"gpio",address,"yes","yes","no",description, NULL, NULL);
				}
			}
		}
		if (hardware.i2c_MinipH.state != -1) {
			XMLCreateDeviceEntry(node,"MinipH",INPUT_RPI_I2C_MINIPH_PREFIX,"yes","no","no","MinipH - mostek pomiarowy pH", NULL, NULL);
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
				sprintf(address,"%s%s",INPUT_RPI_1W_PREFIX,entry->d_name);
				sprintf(description,"Czujnik DS18B20 adres %s",entry->d_name);			
				XMLCreateDeviceEntry(node,"ds18b20",address,"yes","no","no",description, NULL, NULL);
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
						sprintf(address,"%s%s:%i",PORT_RELBRD_PREFIX,entry->d_name,x);
						sprintf(description,"Przekaźnik %i karty RelayBoard wpiętej do %s",x,entry->d_name);
						XMLCreateDeviceEntry(node,"RelayBoard",address,"no","yes","no",description, NULL, NULL);
					}
				}
			}
		}
		closedir(d);
	}

	XMLCreateDeviceEntry(node,"dummy",PORT_DUMMY_PREFIX,"yes","yes","no","Port DUMMY","yes","Numer portu DUMMY");

	if (hardware.RaspiBoardVer > 0) {
		XMLCreateDeviceEntry(node,"system_cpu_temp",INPUT_SYSTEM_CPUTEMP,"yes","no","no","Temperatura procesora", NULL, NULL);
	}
	
	XMLCreateDeviceEntry(node,"system_txtfile",INPUT_SYSTEM_TXTFILE,"yes","no","no","Odczyt z pliku tekstowego","yes","Nazwa pliku tekstowego");
	
	XMLSendReply();	
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
