.PHONY: all force test clean distclean rr update
all: src/parser.c

test: src/parser.c
	tree-sitter test

update: src/parser.c
	tree-sitter test -u

force: out/build.ninja
	ninja -C out grammar.js rr.ebnf
	cp -v out/grammar.js out/rr.ebnf .

clean: clean-treesitter
	rm -rf rr playground build
	-ninja -C out -t clean

distclean: clean
	rm -rf out .fetchcache

rr: out/build.ninja
	ninja -C out rr.zip
	rm -rf rr && mkdir rr && unzip out/rr.zip -d rr

fix-ebnf.diff: out/boogie.ebnf.orig out/boogie.ebnf
	diff -u out/boogie.ebnf.orig out/boogie.ebnf > $@ ; if [ $$? -gt 1 ]; then false; fi

playground: tree-sitter-boogie.wasm
	tree-sitter playground -q --export playground
	sed -i 's|LANGUAGE_BASE_URL = ""|LANGUAGE_BASE_URL = "."|' playground/index.html

B ?= build
BDEP = $(B)/.stamp

BOOGIE_TAR ?= https://github.com/boogie-org/boogie/archive/bc7292d41e938338e27f0771bd195ca9dace16dd.tar.gz
COCOR_CPP_TAR ?= https://github.com/rina-forks/CocoR-CPP/archive/master.tar.gz
EBNF_GEN ?= https://github.com/rina-forks/tree-sitter-ebnf-generator/archive/master.tar.gz
RR_ZIP ?= https://www.bottlecaps.de/rr/download/rr-2.6-java11.zip

FETCH ?= tools/fetch.sh

$(B)/boogie/Source/Core/BoogiePL.atg: $(BDEP) $(FETCH)
	url=$(BOOGIE_TAR) unpack=true strip_leading=true out=$(B)/boogie $(FETCH)


include Makefile.treesitter
