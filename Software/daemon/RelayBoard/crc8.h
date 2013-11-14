/*
 * crc8.h
 *
 *  Created on: 2009-04-16
 *      Author: Kuba
 */

#ifndef CRC8_H_
#define CRC8_H_
#ifndef uint8_t
#define uint8_t unsigned char
#endif /*uint8_t*/
uint8_t CRC8(uint8_t input, uint8_t seed);
uint8_t CountCRC(uint8_t initVal, uint8_t* c, uint8_t size);
#endif /* CRC8_H_ */
