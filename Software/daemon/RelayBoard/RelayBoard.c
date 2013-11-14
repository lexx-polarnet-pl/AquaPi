/*
 ============================================================================
 Name        : RelayBoard.c
 Author      : Jakub �asi�ski
 Version     :
 Copyright   :
 Description : Hello World in C, Ansi-style
 ============================================================================
 */
#include"rb.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//int main(void)
//{
////	OpenComport(3,57600);
////	uint8_t crctab[] = {0x55, 0x01, 0x4f, 0x00, 0x28};
////	SendBuf(3,crctab, 5);    //5 poniewa� ramka ma 5 bajt�w
//	RelayBoardPortInit(NULL);
//	RelayBoardSet(0x01,0xFF);
//	puts("Hello World!!!"); /* prints Hello World!!! */
//	uint8_t val = 0x00;
//	if (RelayBoardGet(0x01,&val) == ERR_NO_ERROR)
//		printf("sukces %x\n", val);
//	RelayBoardPortClose();
//	return EXIT_SUCCESS;
//}
uint8_t debugOn = 0x00;
void PrintHelp()
{
	printf("Relay Board, www.ucprojects.eu\nUsage:\n");
	printf("RelayBoard ComPort [get]    - prints relay value as hexadecimal bit mask\n");
	printf("                              (LSB - relay number 1, MSB - relay number 8)\n");
	printf("                   [set N]  - sets relay value as hexadecimal bit mask\n");
	printf("                   [get N]  - prints (on/off) relay number N state\n");
	printf("                   [on N]   - turns relay number N On\n");
	printf("                   [off N]  - turns relay number N Off\n");
	printf("                   [inv N]  - inverts relay number N state\n");
}
void PrintExample()
{
	printf("\nExample: RelayBoard COM3 get\n");
	printf("         RelayBoard /dev/ttyS0 set 0x23\n");
	printf("         RelayBoard /dev/ttyUSB0 on 2\n");
	printf("         RelayBoard COM123 get 2\n");
}
int main(int argc, char *argv[])
{
	unsigned short j;
	for(j=1;j<argc;j++)
	{
		if (debugOn)
		{
			argv[j] = argv[j+1];
		}
		else
			if (!strcmp(argv[j],"--debug"))
			{
				debugOn = TRUE;
				argc--;
				printf("Debug: debug mode is On.\n");
				if (j != argc)
					argv[j] = argv[j+1];
			}
	}
	if (argc >=2)
	{
		if ((!strcmp(argv[1],"-h"))||(!strcmp(argv[1],"--help")))
		{
			PrintHelp();
			PrintExample();
			return EXIT_SUCCESS;
		}
	}
	if ((argc <= 2)||(argc > 4))
	{
		PrintHelp();
		return EXIT_FAILURE;
	}
	if (RelayBoardPortInit(argv[1]))
		return EXIT_FAILURE;
	if (!strcmp(argv[2],"get"))
	{
		uint8_t errorValue,value;
		if ((errorValue = RelayBoardGet(ADRESS,&value)))
		{
			switch (errorValue)
			{
				case ERR_NO_DATA_RECIVED:
					fprintf(stderr,"Error: no data received from device.\n");
					break;
				case ERR_NO_PREAMBLE_RECIVED:
					fprintf(stderr,"Error: no preamble received from device.\n");
					break;
				case ERR_NO_CRC_MISMATCH:
					fprintf(stderr,"Error: CRC mismatch.\n");
					break;
				case ERR_NOT_FOR_DEVICE:
					fprintf(stderr,"Error: wrong address of the packet.\n");
					break;
				case ERR_WRONG_PACKET_TYPE:
					fprintf(stderr,"Error: wrong packet type (possible echo on port).\n");
					break;
			}
			return EXIT_FAILURE;
		}
		if (argc < 4)
		{
			printf("%02x\n",value);
			return EXIT_SUCCESS;
		}
		int8_t temp;
		sscanf(argv[3],"%hhd",&temp);
		if ((temp <= 8) && (temp >= 1))
		{
			if (value & (1<<(temp-1)))
				printf("on\n");
			else
				printf("off\n");
			return EXIT_SUCCESS;
		}
		else
		{
			fprintf(stderr,"Error: parse error, relay number should be between 1 and 8.\n");
			return EXIT_FAILURE;
		}

	}

	if ((!strcmp(argv[2],"set"))&&(argc == 4))
	{
		uint8_t temp;
		sscanf(argv[3],"%hhx",&temp);
		RelayBoardSet(ADRESS,temp);
		return EXIT_SUCCESS;
	}
	if ((!strcmp(argv[2],"on"))&&(argc == 4))
	{
		int8_t temp;
		sscanf(argv[3],"%hhd",&temp);
		RelayBoardOn(ADRESS,temp-1);
		return EXIT_SUCCESS;
	}
	if ((!strcmp(argv[2],"off"))&&(argc == 4))
	{
		int8_t temp;
		sscanf(argv[3],"%hhd",&temp);
		RelayBoardOff(ADRESS,temp-1);
		return EXIT_SUCCESS;
	}
	if ((!strcmp(argv[2],"inv"))&&(argc == 4))
	{
		int8_t temp;
		sscanf(argv[3],"%hhd",&temp);
		RelayBoardInv(ADRESS,temp -1);
		return EXIT_SUCCESS;
	}
	PrintHelp();
	return EXIT_FAILURE;
}
