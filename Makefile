.PHONY: all force test clean distclean rr
all: src/parser.c

test: src/parser.c
	tree-sitter test

clean: clean-treesitter
	rm -rf boogie.ebnf unpatched.js unpatched.ebnf rr.ebnf rr build

distclean: clean

build/build.ninja:
	meson setup build

rr: build/build.ninja
	meson compile -C build rr.zip
	rm -rf rr && mkdir rr && unzip build/rr.zip -d rr

force: build/build.ninja
	meson install -C build --tags grammar

fix-ebnf.diff: build/boogie.ebnf.orig
	diff -u build/boogie.ebnf.orig build/boogie.ebnf > $@ ; if [ $$? -gt 1 ]; then false; fi

include Makefile.treesitter
