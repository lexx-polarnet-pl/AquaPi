#DEBUG	= -g -O0
DEBUG	= -O3
CC	= gcc
INCLUDE	= -I/usr/local/include
CFLAGS	= $(DEBUG) -Wall $(INCLUDE) -Winline -pipe

LDFLAGS	= -L/usr/local/lib
LIBS    = -lwiringPi -lsqlite3

# Should not alter anything below this line
###############################################################################

SRC	=	aquapi.c

OBJ	=	aquapi.o

all:		aquapi

aquapi:	aquapi.o
	@echo [link]
	$(CC) -o $@ aquapi.o $(LDFLAGS) $(LIBS)

clean:
	rm -f $(OBJ) *~ core tags aquapi

depend:
	makedepend -Y $(SRC)

# DO NOT DELETE
