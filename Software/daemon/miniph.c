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
 
#include <stdio.h>
#include <wiringPi.h>
#include <wiringPiI2C.h>

float pH;
const float vRef = 4.096; 	//Our vRef into the ADC wont be exact
							//Since you can run VCC lower than Vref its
							//best to measure and adjust here
const float opampGain = 5.25; //what is our Op-Amps gain (stage 1)

//Our parameter
struct parameters_T
{
  int pH7Cal, pH4Cal;
  float pHStep;
}
params;

void reset_Params(void)
{
  //Restore to default set of parameters!
  params.pH7Cal = 2048; //assume ideal probe and amp conditions 1/2 of 4096
  params.pH4Cal = 1286; //using ideal probe slope we end up this many 12bit units away on the 4 scale
  params.pHStep = 59.16;//ideal probe slope
}

void calcpHSlope ()
{
	//RefVoltage * our deltaRawpH / 12bit steps *mV in V / OP-Amp gain /pH step difference 7-4
	params.pHStep = ((((vRef*(float)(params.pH7Cal - params.pH4Cal))/4096)*1000)/opampGain)/3;
}

void calcpH(int raw)
{
	float miliVolts = (((float)raw/4096)*vRef)*1000;
	float temp = ((((vRef*(float)params.pH7Cal)/4096)*1000)- miliVolts)/opampGain;
	pH = 7-(temp/params.pHStep);
}

double read_i2c_miniph(void) {
	int fd,val_can;
	reset_Params();
	calcpHSlope ();
    fd = wiringPiI2CSetup(0x4d); 
    val_can = wiringPiI2CReadReg16( fd, 0 );
	val_can = val_can>>8|((val_can<<8)&0xffff);
	calcpH(val_can);
	return pH;
}
