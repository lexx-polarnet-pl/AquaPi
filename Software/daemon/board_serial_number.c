#include <stdio.h> 
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
    FILE *f = fopen("/proc/cpuinfo", "r");
    if (!f) 
    {
	return 1;
    }

    char line[256];
    char serial_string[16 + 1];
    int serial;
    while (fgets(line, 256, f)) 
    {
	if (strncmp(line, "Serial", 6) == 0) 
	{
	serial = atoi(strcpy(serial_string, strchr(line, ':') + 2));
	}
    }
    printf("Serial typu int: %d, oraz jako ciag znakow: %s\n", serial, serial_string);
    return fclose(f);
}
