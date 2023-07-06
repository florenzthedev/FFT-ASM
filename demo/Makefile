#  Copyright (c) 2023 Zachary Todd Edwards
#  MIT License

CC = gcc
LD = gcc
CFLAGS = -Wall -I$(HEDDIR) -fcx-limited-range -g
LFLAGS = -Wl,-rpath='$(LIBDIR)' $(CFLAGS)

SRCDIR = .
HEDDIR = ..
LIBDIR = ..
OBJDIR = ./obj

EXEC = demo

LIBS = -lm -lfft_asm

_DEPS = fft_asm.h
DEPS = $(patsubst %,$(HEDDIR)/%,$(_DEPS))

_OBJ =  demo.o
OBJ = $(patsubst %,$(OBJDIR)/%,$(_OBJ))

$(EXEC): $(OBJ)
	$(LD) -o $@ $(OBJ) -L $(LIBDIR) $(LIBS) $(LFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.c $(DEPS) | $(OBJDIR)
	$(CC) -c -o $@ $< $(CFLAGS)

$(OBJDIR):
	mkdir -p $@

.PHONY: clean

clean:
	rm -f $(OBJDIR)/*.o core $(EXEC)
