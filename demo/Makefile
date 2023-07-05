#  Copyright (c) 2023 Zachary Todd Edwards
#  MIT License

CC = gcc
CFLAGS = -Wall -I$(HEDDIR) -fcx-limited-range

SRCDIR = ./
HEDDIR = ../
ASMDIR = ../
OBJDIR = ./obj

EXEC = demo

LIBS = -lm

_DEPS = fft_asm.h
DEPS = $(patsubst %,$(HEDDIR)/%,$(_DEPS))

_OBJ =  demo.o fft.o
OBJ = $(patsubst %,$(OBJDIR)/%,$(_OBJ))

$(EXEC): $(OBJ)
	$(CC) -o $@ $(OBJ) $(LIBS) $(CFLAGS)

$(OBJDIR)/%.o: $(ASMDIR)/%.s $(DEPS) | $(OBJDIR)
	$(CC) -c -o $@ $< $(CFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.c $(DEPS) | $(OBJDIR)
	$(CC) -c -o $@ $< $(CFLAGS)

$(OBJDIR):
	mkdir -p $@

.PHONY: clean

clean:
	rm -f $(OBJDIR)/*.o core
