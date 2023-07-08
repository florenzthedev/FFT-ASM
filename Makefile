#  Copyright (c) 2023 Zachary Todd Edwards
#  MIT License

CC = gcc
LD = ld
CFLAGS = -Wall -I$(HEDDIR) -fPIC
LFLAGS = -shared -z noexecstack -soname $(EXEC) 

HEDDIR = .
ASMDIR = .
SRCDIR = .
OBJDIR = ./obj

EXEC = libfft_s.so

LIBS = -lm -lc

_DEPS = fft_s.h
DEPS = $(patsubst %,$(HEDDIR)/%,$(_DEPS))

_OBJ = fft.o fft_s.o
OBJ = $(patsubst %,$(OBJDIR)/%,$(_OBJ))

$(EXEC): $(OBJ)
	$(LD) -o $@ $(OBJ) $(LIBS) $(LFLAGS)

$(OBJDIR)/%.o: $(ASMDIR)/%.s $(DEPS) | $(OBJDIR)
	$(CC) -c -o $@ $< $(CFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.c $(DEPS) | $(OBJDIR)
	$(CC) -c -o $@ $< $(CFLAGS)

$(OBJDIR):
	mkdir -p $@

.PHONY: clean

clean:
	rm -f $(OBJDIR)/*.o core $(EXEC)
