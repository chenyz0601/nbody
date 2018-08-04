CC = nvcc
CFLAGS = -I.
DEPS = nbody.h

%.o: %.cu $(DEPS) 
	$(CC) -c -o $@ $< $(CFLAGS)

nbody: acceleration.o initialization.o integration.o main.o
	$(CC) -o nbody acceleration.o initialization.o integration.o main.o -I. 
