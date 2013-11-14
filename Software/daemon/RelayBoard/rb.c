/*
 * rb.c
 *
 *  Created on: 2009-08-20
 *      Author: Kuba
 */

#include "rb.h"
#include "rs232.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

extern uint8_t debugOn;

//static HANDLE rb;
uint8_t RelayBoardPortInit(char* portName)
{
//	char comPort[] = "com3";
//	fPort = fopen(comPort,"rw");
//	if (fPort == NULL)
//		return 1;
	return OpenComport(portName,57600);
}
uint8_t RelayBoardPortClose()
{
//	return fclose(fPort);
	CloseComport();
	return 0x00;
}
uint8_t RelayBoardGet(uint8_t adress,uint8_t* value)
{
	uint8_t i;
	uint8_t result = ERR_NO_DATA_RECIVED;
	uint8_t temp[100];
	for(i=0;i<RETRANSMIT_COUNT;i++)
	{
		while(PollComport(temp,100) > 0)
					;
		//czyszczenie bufora

		RelayBoardSendPacket(adress,CMD_GET,CMD_GET);
		usleep(500000);
		uint8_t buffer[30];
		int val = PollComport(buffer,30);
		if (val <= 0)
		{
			result = ERR_NO_DATA_RECIVED;
			continue;
		}
		//if (debugOn)
		//{
	    	//printf("Debug: Received %d bytes:\n\t",val);
		//	for(i=0;i<PACKET_SIZE;i++)
		//		printf("0x%02X,",buffer[i]);
		//	printf("\n");
		//}
		if (val < 4)
			continue;
		if (buffer[0] != PREAMBLE)
		{
			result = ERR_NO_PREAMBLE_RECIVED;
			continue;
		}
		uint8_t temp = CountCRC(0x00,((uint8_t*)buffer)+1,PACKET_SIZE - 2);
		if (buffer[4] != temp)
		{
			//if (debugOn)
		    	//printf("Debug: CRC Mismatch: \n\t%d != %d (counted != recived)\n",temp,buffer[4]);
			//result = ERR_NO_CRC_MISMATCH;
			//continue;
		}

		if (buffer[1] != adress)
		{
			result = ERR_NOT_FOR_DEVICE;
			continue;
		}
		if (buffer[2] != CMD_GET_REPLY)
		{
			result = ERR_WRONG_PACKET_TYPE;
			continue;
		}
//		result = ERR_NO_ERROR;
		*value = buffer[3];
		return ERR_NO_ERROR;
	}
	return result;
}
//Sets the relay value to the board
void RelayBoardSet(uint8_t adress,uint8_t value)
{
	RelayBoardSendPacket(adress,CMD_SET,value);
}
//Turns selected relays On
void RelayBoardOn(uint8_t adress,uint8_t value)
{
	RelayBoardSendPacket(adress,CMD_ON,value);
}
//Turns selected relays Off
void RelayBoardOff(uint8_t adress,uint8_t value)
{
	RelayBoardSendPacket(adress,CMD_OFF,value);
}
void RelayBoardInv(uint8_t adress,uint8_t value)
{
	RelayBoardSendPacket(adress,CMD_XOR,value);
}
void RelayBoardSendPacket(uint8_t adress,uint8_t cmd, uint8_t arg)
{
	struct Packet_t packet;
	packet.preamble = PREAMBLE;
	packet.address = adress;
	packet.command = cmd;
	packet.argument = arg;
	packet.crc = CountCRC(0x00,((uint8_t*)&packet)+1,PACKET_SIZE - 2);
	RelayBoardSendData(packet);
}
void RelayBoardSendData(struct Packet_t packetToSend)
{
//	int8_t* bytesToSend;
	uint8_t bytesToSend[5];
//	uint8_t i;
	bytesToSend[0] = (uint8_t)packetToSend.preamble;
	bytesToSend[1] = (uint8_t)packetToSend.address;
	bytesToSend[2] = (uint8_t)packetToSend.command;
	bytesToSend[3] = (uint8_t)packetToSend.argument;
	bytesToSend[4] = (uint8_t)packetToSend.crc;
    //if (debugOn)
    //	printf("Debug: Sending packet:\n\t0x%02X,0x%02X,0x%02X,0x%02X,0x%02X\n",packetToSend.preamble,
//			packetToSend.address,packetToSend.command,
//			packetToSend.argument,packetToSend.crc);
//	for(i=0;i<PACKET_SIZE;i++)
//		printf("0x%02X,",bytesToSend[i]);
	SendBuf(bytesToSend,PACKET_SIZE);
}
