/*
 * rb.h
 *
 *  Created on: 2009-08-19
 *      Author: Kuba
 */

#ifndef RB_H_
#define RB_H_
#include "crc8.h"
#include <unistd.h>
typedef unsigned char uint8_t;
//#define TRUE 0x01
//#define FALSE 0x00
#define RETRANSMIT_COUNT 5
#define DELAY 100

#define ERR_NO_ERROR 0x00
#define ERR_NO_DATA_RECIVED 0x01
#define ERR_NO_PREAMBLE_RECIVED 0x02
#define ERR_NO_CRC_MISMATCH 0x03
#define ERR_NOT_FOR_DEVICE 0x04
#define ERR_WRONG_PACKET_TYPE 0x05

//Packet field position
#define PF_PREAMBLE 0x00
#define PF_ADRESS 0x01
#define PF_COMMAND 0x02
#define PF_ARGUMENT 0x03
#define PF_CRC 0x04

//packet signatures
#define CMD_GET 'G'
#define CMD_SET 'S'
#define CMD_ON 'O'
#define CMD_OFF 'F'
#define CMD_XOR '^'
#define CMD_GET_REPLY 'R'

#define PACKET_SIZE 5
#define PREAMBLE 0x55
#define ADRESS 0x01

struct Packet_t
{
	uint8_t preamble;
	uint8_t address;
	uint8_t command;
	uint8_t argument;
	uint8_t crc;
};
uint8_t RelayBoardGet(uint8_t adress,uint8_t* value);
//Sets the relay value to the board
void RelayBoardSet(uint8_t adress,uint8_t value);
//Turns selected relays On
void RelayBoardOn(uint8_t adress,uint8_t value);
//Turns selected relays Off
void RelayBoardOff(uint8_t adress,uint8_t value);
//Turns logic xor of the relays value
void RelayBoardInv(uint8_t adress,uint8_t value);

uint8_t RelayBoardPortInit(char* portName);
uint8_t RelayBoardPortClose();
//uint8_t RelayBoardGet(uint8_t adress,uint8_t* value);
////Sets the relay value to the board
//void RelayBoardSet(uint8_t adress,uint8_t value);
////Turns selected relays On
//void RelayBoardOn(uint8_t adress,uint8_t value);
////Turns selected relays Off
//void RelayBoardOff(uint8_t adress,uint8_t value);
void RelayBoardSendPacket(uint8_t adress,uint8_t cmd, uint8_t arg);
void RelayBoardSendData(struct Packet_t packetToSend);

#endif /* RB_H_ */
