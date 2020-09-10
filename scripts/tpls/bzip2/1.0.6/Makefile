# ------------------------------------------------------------------
# This file is part of bzip2/libbzip2, a program and library for
# lossless, block-sorting data compression.
#
# bzip2/libbzip2 version 1.0.6 of 6 September 2010
# Copyright (C) 1996-2010 Julian Seward <jseward@bzip.org>
#
# Please read the WARNING, DISCLAIMER and PATENTS sections in the 
# README file.
#
# This program is released under the terms of the license contained
# in the file LICENSE.
# ------------------------------------------------------------------

# To assist in cross-compiling
CC=clang
AR=libtool
LDFLAGS=

BIGFILES=-D_FILE_OFFSET_BITS=64
CFLAGS=-Wall -Winline -O2 $(BIGFILES) -fembed-bitcode-marker -isysroot $(ISYSROOT)

OBJS= blocksort.o  \
      huffman.o    \
      crctable.o   \
      randtable.o  \
      compress.o   \
      decompress.o \
      bzlib.o

all: libbz2.a

libbz2.a: $(OBJS)
	rm -f libbz2.a
	$(AR) -static -o libbz2.a $(OBJS)

clean: 
	rm -f *.o libbz2.a bzip2 bzip2recover \
	sample1.rb2 sample2.rb2 sample3.rb2 \
	sample1.tst sample2.tst sample3.tst

blocksort.o: blocksort.c
	@cat words0
	$(CC) $(CFLAGS) -c blocksort.c
huffman.o: huffman.c
	$(CC) $(CFLAGS) -c huffman.c
crctable.o: crctable.c
	$(CC) $(CFLAGS) -c crctable.c
randtable.o: randtable.c
	$(CC) $(CFLAGS) -c randtable.c
compress.o: compress.c
	$(CC) $(CFLAGS) -c compress.c
decompress.o: decompress.c
	$(CC) $(CFLAGS) -c decompress.c
bzlib.o: bzlib.c
	$(CC) $(CFLAGS) -c bzlib.c
bzip2.o: bzip2.c
	$(CC) $(CFLAGS) -c bzip2.c
bzip2recover.o: bzip2recover.c
	$(CC) $(CFLAGS) -c bzip2recover.c


distclean: clean
	rm -f manual.ps manual.html manual.pdf


