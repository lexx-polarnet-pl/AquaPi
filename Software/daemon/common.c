#include <stdio.h>
#include <stdlib.h>
#include <printf.h>
#include <math.h>
#include <string.h>
#include <sys/utsname.h>
#include <sys/sysinfo.h>
#include <time.h>
#include <ctype.h>

float Get_Numeric_From_File(char *sensor_id) {
    FILE *fp;
	char buff[50];

	fp = fopen (sensor_id, "r");
	if( fp == NULL ) {
		return -100;
	} else {
		fgets(buff, 50, fp);
		fclose (fp);	
		return (float)atoi(buff);
	}
}

/*
 * piBoardRev:
 *      Return a number representing the hardware revision of the board.
 *      Revision is currently 1 or 2. -1 is returned on error.
 *
 *      Much confusion here )-:
 *      Seems there are some boards with 0000 in them (mistake in manufacture)
 *      and some board with 0005 in them (another mistake in manufacture?)
 *      So the distinction between boards that I can see is:
 *      0000 - Error
 *      0001 - Not used
 *      0002 - Rev 1
 *      0003 - Rev 1
 *      0004 - Rev 2 (Early reports?
 *      0005 - Rev 2 (but error?)
 *      0006 - Rev 2
 *      0008 - Rev 2 - Model A
 *      000e - Rev 2 + 512MB
 *      000f - Rev 2 + 512MB
 *
 *      A small thorn is the olde style overvolting - that will add in
 *              1000000
 *
 *********************************************************************************
 */

int piBoardRev_noOops (void)
{
  FILE *cpuFd ;
  char line [120] ;
  char *c, lastChar ;
  static int  boardRev = -1 ;

  if (boardRev != -1)   // No point checking twice
    return boardRev ;

  if ((cpuFd = fopen ("/proc/cpuinfo", "r")) == NULL)
    //piBoardRevOops ("Unable to open /proc/cpuinfo") ;
	return -2;

  while (fgets (line, 120, cpuFd) != NULL)
    if (strncmp (line, "Revision", 8) == 0)
      break ;

  fclose (cpuFd) ;

  if (strncmp (line, "Revision", 8) != 0)
    //piBoardRevOops ("No \"Revision\" line") ;
	return -3;

  for (c = &line [strlen (line) - 1] ; (*c == '\n') || (*c == '\r') ; --c)
    *c = 0 ;

  for (c = line ; *c ; ++c)
    if (isdigit (*c))
      break ;

  if (!isdigit (*c))
    //piBoardRevOops ("No numeric revision string") ;
	return -4;

// If you have overvolted the Pi, then it appears that the revision
//      has 100000 added to it!

  lastChar = line [strlen (line) - 1] ;

  if ((lastChar == '2') || (lastChar == '3'))
    boardRev = 1 ;
  else
    boardRev = 2 ;

  return boardRev ;
}
