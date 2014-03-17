#DEBUG	= -g -O0
DEBUG	= -O3
CC	= gcc
INCLUDE	= -I/usr/local/include -I/usr/include/mysql -I./RelayBoard
CFLAGS	= $(DEBUG) -Wall $(INCLUDE) -Winline -pipe -lpthread

LDFLAGS	= -L/usr/local/lib -lpthread
LIBS    = -lwiringPi -lmysqlclient_r

# Should not alter anything below this line
###############################################################################

SRC	=	aquapi.c

OBJ	=	aquapi.o

all:		aquapi

aquapi:	aquapi.o
	$(CC) -c RelayBoard/crc8.c -o RelayBoard/crc8.o
	$(CC) -c RelayBoard/rs232.c -o RelayBoard/rs232.o
	$(CC) -c RelayBoard/rb.c -o RelayBoard/rb.o
	@echo [link]
	$(CC) -o $@ aquapi.o RelayBoard/*.o $(LDFLAGS) $(LIBS)

clean:
	rm -f $(OBJ) RelayBoard/*.o *~ core tags aquapi
install:
	cp aquapi /usr/local/aquapi/

# DO NOT DELETE
