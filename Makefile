.PHONY: all clean distclean
all: grammar.js src/parser.c

clean: clean-treesitter
	rm -rf boogie.ebnf grammar.js unpatched.js

distclean: clean
	rm -rf Boogie CocoR-CPP tree-sitter-ebnf-generator

BOOGIE_TAR ?= https://github.com/boogie-org/boogie/archive/bc7292d41e938338e27f0771bd195ca9dace16dd.tar.gz
COCOR_CPP_TAR ?= https://github.com/rina-forks/CocoR-CPP/archive/master.tar.gz
EBNF_GEN ?= https://github.com/rina-forks/tree-sitter-ebnf-generator/archive/master.tar.gz

Boogie/Source/Core/BoogiePL.atg:
	rm -rf Boogie
	cd `mktemp -d` && wget -O - $(BOOGIE_TAR) | tar xzf - && mv boogie-* $(CURDIR)/Boogie

CocoR-CPP/src/Coco.cpp:
	rm -rf CocoR-CPP
	cd `mktemp -d` && wget -O - $(COCOR_CPP_TAR) | tar xzf - && mv CocoR-CPP-* $(CURDIR)/CocoR-CPP

CocoR-CPP/src/Coco: CocoR-CPP/src/Coco.cpp
	make -C CocoR-CPP/src

boogie.ebnf: CocoR-CPP/src/Coco Boogie/Source/Core/BoogiePL.atg fix-ebnf.sh
	$< Boogie/Source/Core/BoogiePL.atg -genRREBNF -frames CocoR-CPP/src
	./fix-ebnf.sh < Boogie/Source/Core/Parser.ebnf > $@

tree-sitter-ebnf-generator/src/lua/parse_grammar.lua:
	rm -rf tree-sitter-ebnf-generator
	cd `mktemp -d` && wget -O - $(EBNF_GEN) | tar xzf - \
		&& mv tree-sitter-ebnf-generator-* $(CURDIR)/tree-sitter-ebnf-generator

unpatched.js: tree-sitter-ebnf-generator/src/lua/parse_grammar.lua boogie.ebnf fix-grammar.sh
	$< boogie.ebnf \
		| ./fix-grammar.sh > $@

grammar.js: unpatched.js fix-grammar.diff
	cp $< $@
	if ! patch $@ --merge -i fix-grammar.diff; then touch -d '2004-02-29 00:00:00' $@; false; fi

fix-grammar.diff:
	diff -u unpatched.js grammar.js > $@; if [ $$? -gt 1 ]; then false; fi

include Makefile.treesitter
