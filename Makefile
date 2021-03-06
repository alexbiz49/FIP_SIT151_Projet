#
# 'make depend' uses makedepend to automatically generate dependencies
#               (dependencies are added to end of Makefile)
# 'make'        build executable file 'mycc'
# 'make clean'  removes all .o and executable files
#

# define the C compiler to use
CC = gcc

# define any compile-time flags
CFLAGS = `sdl-config --cflags --libs` -g -std=c99

WARNINGS=-Wstrict-prototypes -Wmissing-prototypes -Wold-style-definition -Wextra
#-Wall

# define any directories containing header files other than /usr/include
#
# INCLUDES = -I/home/newhall/include  -I../include
INCLUDES = -Iinc

# define library paths in addition to /usr/lib
#   if I wanted to include libraries not in /usr/lib I'd specify
#   their path using -Lpath, something like:
# LFLAGS = -L/home/newhall/lib  -L../lib
LFLAGS =

# define any libraries to link into executable:
#   if I want to link in libraries (libx.so or libx.a) I use the -llibname
#   option, something like (this will link in libmylib.so and libm.so:
# LIBS = -lmylib -lm
LIBS = -lSDL_ttf -lm -lSDL

# define the C source files
SRCS = src/main.c src/linkedlist.c src/sprite.c src/collider.c src/level.c src/trace.h src/score.h
#display.c

# define the C object files
#
# This uses Suffix Replacement within a macro:
#   $(name:string1=string2)
#         For each word in 'name' replace 'string1' with 'string2'
# Below we are replacing the suffix .c of all words in the macro SRCS
# with the .o suffix
#

OBJDIR = ../build
SRCDIR = ../src

#OBJS = $(SRCS:.c=.o)
OBJS = $(patsubst $(SRCDIR)/%.c,$(OBJDIR)/%.o,$(SRCS))

# define the executable file
MAIN = build/cometbuster_exe

#
# The following part of the makefile is generic; it can be used to
# build any executable just by changing the definitions above and by
# deleting dependencies appended to the file from 'make depend'
#

.PHONY: depend clean

all:  $(MAIN)
	@echo  "Everything has been compiled, w00t!"

$(MAIN): $(OBJS)
	@echo "OBJS = $(OBJS)"
	$(CC) $(OBJS) $(CFLAGS) $(WARNINGS) $(INCLUDES) -o $(MAIN) $(LFLAGS) $(LIBS)

# this is a suffix replacement rule for building .o's from .c's
# it uses automatic variables $<: the name of the prerequisite of
# the rule(a .c file) and $@: the name of the target of the rule (a .o file)
# (see the gnu make manual section about automatic variables)
$(OBJDIR)/%.o: $(SRCDIR)/%.c
	mkdir -p build
	$(CC) $(CFLAGS) $(WARNINGS) $(INCLUDES) -c $<  -o $@

clean:
	$(RM) *.o *~ $(MAIN)

depend: $(SRCS)
	makedepend $(INCLUDES) $^
	
install: all
	mkdir -p install
	cp build/cometbuster_exe install/cometbuster_exe

# DO NOT DELETE THIS LINE -- make depend needs it
