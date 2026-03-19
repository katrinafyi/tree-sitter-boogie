
.PHONY: all clean
all: boogie.ebnf

clean: clean-treesitter
	rm -rf Boogie CocoR-CPP boogie.ebnf tree-sitter-ebnf-generator

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

grammar.js: tree-sitter-ebnf-generator/src/lua/parse_grammar.lua boogie.ebnf fix-grammar
	$< boogie.ebnf \
		| ./fix-grammar.sh > $@

include Makefile.treesitter
