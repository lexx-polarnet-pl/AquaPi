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
 
#include <stdio.h>
#include <wiringPi.h>
#include <wiringPiI2C.h>

// bufor próbek
int buff[100];
	
double read_i2c_miniph(void) {
	int val_can,avr_val,temp,i,j;
	int buff2[100];
	// zczytaj dane z MiniPh
	val_can = wiringPiI2CReadReg16(hardware.i2c_MinipH.fd, 0 );
	val_can = val_can>>8|((val_can<<8)&0xffff);
	// przesuń bufor pomiarów i dopisz nową wartość na końcu (albo tam gdzie są zera)
	for (i=0;i<99;i++) {
		buff[i] = buff[i+1];
		if (buff[i] == 0) {
			buff[i] = val_can;
		}
	}
	buff[99] = val_can;
	// przepisz bufor do drugiego bufora
	for (i=0;i<100;i++) {
		buff2[i] = buff[i];
	}
	// posortuj próbki w drugim buforze
	for(i=0;i<100;i++) {
		for(j=i+1;j<100;j++) {
			if(buff2[i]>buff2[j]) {
				temp=buff2[i];
				buff2[i]=buff2[j];
				buff2[j]=temp;
			}
		}
	}
	// wyciągnij średnią z 80 próbek, pomiając 10 skrajnych z każdej strony
	avr_val=0;
	for(i=10;i<90;i++) avr_val+=buff2[i];
	// zwróć średnią z 80 próbek zebranych w ciągu 100 sekund
	return avr_val/80;
}
