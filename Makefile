.PHONY: all force test clean distclean rr update
all: src/parser.c

test: src/parser.c
	tree-sitter test

update: src/parser.c
	tree-sitter test -u

clean: clean-treesitter
	rm -rf boogie.ebnf unpatched.js unpatched.ebnf rr build playground
	-ninja -C out -t clean

distclean: clean
	rm -rf out

out/build.ninja:
	gn gen out

rr: out/build.ninja
	ninja -C out rr.zip
	rm -rf rr && mkdir rr && unzip out/rr.zip -d rr

force: out/build.ninja
	ninja -C out grammar.js rr.ebnf
	cp -v out/{grammar.js,rr.ebnf} .

fix-ebnf.diff: out/boogie.ebnf.orig out/boogie.ebnf
	diff -u out/boogie.ebnf.orig out/boogie.ebnf > $@ ; if [ $$? -gt 1 ]; then false; fi

playground: tree-sitter-boogie.wasm
	tree-sitter playground -q --export playground
	sed -i 's|LANGUAGE_BASE_URL = ""|LANGUAGE_BASE_URL = "."|' playground/index.html

include Makefile.treesitter
