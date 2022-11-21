

# ------------------------------------------------
# Generic Makefile
#
# Author: yanick.rochon@gmail.com
# Date  : 2011-08-10
#
# Changelog :
#   2010-11-05 - first version
#   2011-08-10 - added structure : sources, objects, binaries
#				thanks to http://stackoverflow.com/users/128940/beta
#   2017-04-24 - changed order of linker params
# ------------------------------------------------

# -------------------
# CCCP Makefile
# Modified by: PKD
#--------------------

LIBOUT = libspm.so


CC = gcc
CPP = g++

ODIR = obj
SDIR = src


CFLAGS = -Wall -g -fPIC -O2 -Wextra -fPIC -L./bin

LIBS = -lcurl -lsqlite3 -lm 

# change these to proper directories where each file should be
SRCDIR   = src
OBJDIR   = obj
BINDIR   = bin

SOURCES  := $(wildcard $(SRCDIR)/*.c)
INCLUDES := $(wildcard $(SRCDIR)/*.h)
OBJECTS  := $(SOURCES:$(SRCDIR)/%.c=$(OBJDIR)/%.o)

FMT_DIR = formats


all: $(BINDIR)/$(LIBOUT)
	@echo "BUILD SUCESSFUL"

$(BINDIR)/$(LIBOUT): $(OBJECTS)
	@$(CC) $(OBJECTS) $(LIBS) $(LFLAGS) -o $@ -shared
	@echo "Linking complete!"

$(OBJECTS): $(OBJDIR)/%.o : $(SRCDIR)/%.c

	@if [ ! -d $(OBJDIR) ]; then mkdir $(OBJDIR); fi
	@if [ ! -d $(BINDIR) ]; then mkdir $(BINDIR); fi

	@$(CC) $(CFLAGS) -c $< -o $@
	@echo "Compiled "$<" successfully!"



test:
	$(CC) $(CFLAGS) -DSTATIC ${FMT_DIR}/*/* tests/test.c $(LIBS) -o bin/spm-test -lspm -L./bin

direct:
	$(CC) $(CFLAGS) $(SRCS) $(LIBS) -shared -fPIC -o $(LIBOUT)

formats:
	@echo "Building formats..."
	@echo $(FMT_DIR)/*
	for i in $(FMT_DIR)/*; do \
		echo "Building $$i"; \
		if [ -d $$i ]; then \
			$(CC) $(CFLAGS) -shared -fPIC $$i/*.c -o $(BINDIR)/plugins/$$(basename $$i).so; \
		fi; \
	done

.PHONY: clean test

clean:
	rm -f $(ODIR)/*.o $(BINDIR)/$(LIBOUT) $(BINDIR)/$(EXEOUT) $(BINDIR)/plugins/*.so 

install:
	if [ ! -d "/usr/local/lib/spm" ]; then mkdir -p /usr/local/lib/spm; fi
	cp -rf include/* $(DESTDIR)/usr/include/spm
	cp $(BINDIR)/$(LIBOUT) $(DESTDIR)/lib
	cp -rf $(BINDIR)/plugins/* $(DESTDIR)/var/cccp/plugins


	


