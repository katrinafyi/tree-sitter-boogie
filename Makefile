.PHONY: all force test clean distclean rr update
all: src/parser.c

test: src/parser.c
	tree-sitter test

update: src/parser.c
	tree-sitter test -u

clean: clean-treesitter
	rm -rf boogie.ebnf unpatched.js unpatched.ebnf rr build playground
	meson subprojects purge --confirm

distclean: clean
	rm -rf subprojects/packagecache

subprojects/rr:
	! meson subprojects download rr
	rm -rf subprojects/rr
	mkdir subprojects/rr && cp subprojects/packagecache/rr.jar subprojects/rr
	meson subprojects packagefiles --apply rr

build/build.ninja: subprojects/rr
	meson setup build

rr: build/build.ninja
	meson compile -C build rr.zip
	rm -rf rr && mkdir rr && unzip build/rr.zip -d rr

force: build/build.ninja
	meson install -C build --tags grammar

fix-ebnf.diff: build/boogie.ebnf.orig
	diff -u build/boogie.ebnf.orig build/boogie.ebnf > $@ ; if [ $$? -gt 1 ]; then false; fi

playground: tree-sitter-boogie.wasm
	tree-sitter playground -q --export playground
	sed -i 's|LANGUAGE_BASE_URL = ""|LANGUAGE_BASE_URL = "."|' playground/index.html

include Makefile.treesitter
