# Compiler and Compile options.
CC = gcc
# CFLAGS = -g -Wall
CFLAGS = -g 
ADFLAGS = -lpthread -lz

# Macros specifying path for compile.
SRCS := $(wildcard *.c)
OBJS := $(SRCS:.c=.o)

all: client server
all = client server


client: client.c llc.c mac.c 
	$(CC) $(CFLAGS) -o client client.c llc.c mac.c $(ADFLAGS) 


server: server.c llc.c mac.c
	$(CC) $(CFLAGS) -o server server.c llc.c mac.c  $(ADFLAGS)



# Delete binary & object files
clean:
	rm -rf $(all) $(OBJS)

