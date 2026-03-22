.PHONY: all force test clean distclean rr update
all: src/parser.c

test: src/parser.c
	tree-sitter test

update: src/parser.c
	tree-sitter test -u

clean: clean-treesitter
	rm -rf rr playground build

distclean: clean
	rm -rf out .fetchcache

playground: tree-sitter-boogie.wasm
	tree-sitter playground -q --export playground
	sed -i 's|LANGUAGE_BASE_URL = ""|LANGUAGE_BASE_URL = "."|' playground/index.html

# ===== FETCHED URLS =====

BOOGIE_TAR ?= https://github.com/boogie-org/boogie/archive/bc7292d41e938338e27f0771bd195ca9dace16dd.tar.gz
COCOR_CPP_TAR ?= https://github.com/rina-forks/CocoR-CPP/archive/master.tar.gz
EBNF_GEN ?= https://github.com/rina-forks/tree-sitter-ebnf-generator/archive/master.tar.gz
RR_ZIP ?= https://repo1.maven.org/maven2/de/bottlecaps/rr/rr-webapp/2.6/rr-webapp-2.6.war

# ===== BUILD DIRECTORY SETUP =====

b ?= build
bdep = $(b)/.stamp

$(bdep):
	mkdir -p $(b) && touch $@

# ===== FETCHED DEPENDENCIES =====

fetch ?= tools/fetch.sh

boogie_atg = $(b)/boogie/Source/Core/BoogiePL.atg
$(boogie_atg): $(bdep) $(fetch)
	url=$(BOOGIE_TAR) unpack=true strip_leading=true out=$(b)/boogie $(fetch)

coco = $(b)/Coco
$(coco): $(bdep) $(fetch)
	url=$(COCOR_CPP_TAR) unpack=true strip_leading=true out=$(b)/cocor-cpp $(fetch)
	cd $(b)/cocor-cpp/src && $(CXX) -g -Wall -fno-rtti -fno-exceptions *.cpp -o Coco -fsanitize=address $(CFLAGS) $(CXXFLAGS)
	mv $(b)/cocor-cpp/src/Coco $@

parse_grammar = $(b)/parse_grammar.lua
$(parse_grammar): $(bdep) $(fetch)
	url=$(EBNF_GEN) unpack=true strip_leading=true out=$(b)/ts-ebnf-gen $(fetch)
	mv $(b)/ts-ebnf-gen/src/lua/parse_grammar.lua $@

rr_jar = $(b)/rr.war
$(rr_jar): $(bdep) $(fetch)
	url=$(RR_ZIP) unpack=false strip_leading=false out=$@ $(fetch)

# ===== GRAMMAR FILES =====

boogie_coco_ebnf = $(b)/coco.ebnf
$(boogie_coco_ebnf): $(coco) $(boogie_atg) frames/Parser.frame frames/Scanner.frame
	$(coco) $(boogie_atg) -genRREBNF -frames frames -o $(b)
	mv $(b)/Parser.ebnf $@

boogie_ts_ebnf = $(b)/boogie.ebnf.orig
$(boogie_ts_ebnf): fix-ebnf.sh $(boogie_coco_ebnf)
	./$< $(boogie_coco_ebnf) $@

boogie_patched_ebnf = $(b)/boogie.ebnf
$(boogie_patched_ebnf): fix-ebnf.diff $(boogie_ts_ebnf)
	patch --verbose --merge --output $@ -i $< $(boogie_ts_ebnf)

grammar_js = $(b)/grammar.js
$(grammar_js): $(parse_grammar) $(boogie_patched_ebnf) fix-grammar.sh
	$(parse_grammar) $(boogie_patched_ebnf) > $(b)/grammar.js.orig
	./fix-grammar.sh $(b)/grammar.js.orig $@

# ===== RAILROAD DIAGRAM FILES =====

rr_ebnf = $(b)/rr.ebnf
$(rr_ebnf): $(boogie_coco_ebnf) to-hash-x.sh
	./to-hash-x.sh < $(boogie_coco_ebnf) > $@

rr_zip = $(b)/rr.zip
$(rr_zip): $(rr_jar) $(rr_ebnf)
	java -jar $(rr_jar) -html -noembedded -out:$@ $(rr_ebnf)

# ===== PUBLIC TARGETS =====

force: $(grammar_js) $(rr_ebnf)
	cp -v $^ .

rr: $(rr_zip)
	rm -rf $@ && mkdir $@ && unzip $< -d $@

fix-ebnf.diff:  # should be used with -B / --always-make
	diff -u $(boogie_ts_ebnf) $(boogie_patched_ebnf) > $@ ; if [ $$? -gt 1 ]; then false; fi



include Makefile.treesitter
