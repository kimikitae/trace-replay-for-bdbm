
TARGET =  trace_replay 
SRCS   =  trace_replay.o disk_io.o sgio.o identify.o

CFLAGS :=  -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64   
LDFLAGS := -lpthread -laio -lrt

GLIB_INCLUDES = $(shell pkg-config --cflags glib-2.0)

GLIB_LIBS = $(shell pkg-config --libs glib-2.0)

DEVICE_INCLUDES += -I/usr/local/include/ftl -I/usr/local/include/memio 

LIBS := -lm -lpthread  $(GLIB_LIBS)

INCLUDES := -I./include $(GLIB_INCLUDES) $(DEVICE_INCLUDES)

OBJS=$(SRCS:.c=.o)

	
.SUFFIXES: .c .o

# .PHONY: all clean

.c.o:
	@echo "Compiling $< ..."
	@$(RM) $@
	g++ -c -O2  -D_GNU_SOURCE $(CFLAGS) $(LIBS) $(INCLUDES) -L./libftl.a -L./libmemio.a  -o $@ $<

$(TARGET): $(OBJS)
	@echo "Making ./$(TARGET) ..."
	@echo "$(CC) -o $@ $(OBJS) $(LDFLAGS) -L. -lftl"
	@g++ -o $@ -lpthread $(LIBS) $(INCLUDES) $(OBJS) $(GLIB_LIBS) $(GLIB_INCLUDES) $(LDFLAGS) -L. -lftl -L/usr/local/ -lmemio


all:    $(TARGET) 

clean:
	rm -f *.o *~ $(TARGET)

distclean:
	rm -f Makefile.bak *.o *.a *~ .depend $(TARGET)
install: 
	cp $(TARGET) /usr/local/bin

uninstall:

dep:    depend

depend:
	$(CC) -MM $(CFLAGS) $(SRCS) 1>.depend

#
# include dependency files if they exist
#
ifneq ($(wildcard .depend),)
include .depend
endif

