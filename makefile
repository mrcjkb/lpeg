LIBNAME = lpeg
LUADIR = ../lua/

COPT = -O2 -DNDEBUG
# COPT = -g

CWARNS = -Wall -Wextra -pedantic \
	-Waggregate-return \
	-Wcast-align \
	-Wcast-qual \
	-Wdisabled-optimization \
	-Wpointer-arith \
	-Wshadow \
	-Wsign-compare \
	-Wundef \
	-Wwrite-strings \
	-Wbad-function-cast \
	-Wdeclaration-after-statement \
	-Wmissing-prototypes \
	-Wnested-externs \
	-Wstrict-prototypes \
# -Wunreachable-code \


CFLAGS = $(CWARNS) $(COPT) -std=c99 -I$(LUADIR) -fPIC
CC = gcc

FILES = lpvm.o lpcap.o lptree.o lpcode.o lpprint.o

# For Linux
linux:
	$(MAKE) liblpeg.so "DLLFLAGS = -shared -fPIC" "OUT = liblpeg.so"

# For Mac OS
macosx:
	$(MAKE) lpeg.dylib "DLLFLAGS = -dynamiclib -undefined dynamic_lookup" "OUT = lpeg.dylib"

liblpeg.so: $(FILES)
	env $(CC) $(DLLFLAGS) $(FILES) -o $(OUT)

$(FILES): makefile

test: test.lua re.lua $(OUT)
	./test.lua

clean:
	rm -f $(FILES) $(OUT)


lpcap.o: lpcap.c lpcap.h lptypes.h
lpcode.o: lpcode.c lptypes.h lpcode.h lptree.h lpvm.h lpcap.h
lpprint.o: lpprint.c lptypes.h lpprint.h lptree.h lpvm.h lpcap.h
lptree.o: lptree.c lptypes.h lpcap.h lpcode.h lptree.h lpvm.h lpprint.h
lpvm.o: lpvm.c lpcap.h lptypes.h lpvm.h lpprint.h lptree.h

