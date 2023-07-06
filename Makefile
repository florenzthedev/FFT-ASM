#  Copyright (c) 2023 Zachary Todd Edwards
#  MIT License

CC = gcc
LD = gcc
CFLAGS = -Wall -I$(HEDDIR) -fPIC
LFLAGS = -shared -Wl,-soname,$(EXEC) $(CFLAGS)

HEDDIR = .
ASMDIR = .
OBJDIR = ./obj

EXEC = libfft_asm.so

LIBS = -lm -lc

_DEPS = fft_asm.h
DEPS = $(patsubst %,$(HEDDIR)/%,$(_DEPS))

_OBJ = fft.o
OBJ = $(patsubst %,$(OBJDIR)/%,$(_OBJ))

$(EXEC): $(OBJ)
	$(LD) -o $@ $(OBJ) $(LIBS) $(LFLAGS)

$(OBJDIR)/%.o: $(ASMDIR)/%.s $(DEPS) | $(OBJDIR)
	$(CC) -c -o $@ $< $(CFLAGS)

$(OBJDIR):
	mkdir -p $@

demo: $(EXEC)
	$(MAKE) -C demo

.PHONY: clean

clean:
	rm -f $(OBJDIR)/*.o core $(EXEC)
	$(MAKE) clean -C demo
