.PHONY: all force test clean distclean rr update
all: src/parser.c

test: src/parser.c
	tree-sitter test

update: src/parser.c
	tree-sitter test -u

clean: clean-treesitter
	rm -rf rr playground build docs tree-sitter-boogie.tar.gz

distclean: clean
	rm -rf out .fetchcache

playground: tree-sitter-boogie.wasm
	tree-sitter playground -q --export playground
	sed -i 's|LANGUAGE_BASE_URL = ""|LANGUAGE_BASE_URL = "."|' playground/index.html

# ===== DEPENDENCY URLS =====

BOOGIE_TAR ?= https://github.com/boogie-org/boogie/archive/bc7292d41e938338e27f0771bd195ca9dace16dd.tar.gz
COCOR_CPP_TAR ?= https://github.com/rina-forks/CocoR-CPP/archive/e968eb7da7295125dcc1ba45c6616d94bbfd6ddd.tar.gz
EBNF_GEN ?= https://github.com/rina-forks/tree-sitter-ebnf-generator/archive/89fde0613e62a3cad0ae66504ea3f31b9a9d6976.tar.gz
RR_ZIP ?= https://repo1.maven.org/maven2/de/bottlecaps/rr/rr-webapp/2.6/rr-webapp-2.6.war

# ===== BUILD DIRECTORY AND TOOLS =====

b ?= build
bdep = $(b)/.stamp

$(bdep):
	mkdir -p $(b) && touch $@

tools/coco-ebnf-to-ts-ebnf.sh: tools/ts-ebnf-fix-ll.py
	touch $@  # $^ is a runtime dependency of $<

# ===== FETCHED DEPENDENCIES =====

fetch ?= tools/fetch.sh

boogie_atg = $(b)/boogie/Source/Core/BoogiePL.atg
$(boogie_atg): $(bdep) $(fetch)
	url=$(BOOGIE_TAR) unpack=true strip_leading=true out=$(b)/boogie $(fetch)

coco = $(b)/Coco
$(coco): $(bdep) $(fetch)
	url=$(COCOR_CPP_TAR) unpack=true strip_leading=true out=$(b)/cocor-cpp $(fetch)
	$(MAKE) -C $(b)/cocor-cpp/src
	mv $(b)/cocor-cpp/src/Coco $@

parse_grammar = $(b)/parse_grammar.lua
$(parse_grammar): $(bdep) $(fetch)
	url=$(EBNF_GEN) unpack=true strip_leading=true out=$(b)/ts-ebnf-gen $(fetch)
	mv $(b)/ts-ebnf-gen/src/lua/parse_grammar.lua $@

rr_jar = $(b)/rr.war
$(rr_jar): $(bdep) $(fetch)
	url=$(RR_ZIP) unpack=false strip_leading=false out=$@ $(fetch)

# ===== GRAMMAR FILES =====

boogie_coco_ebnf = $(b)/coco.ebnf.orig
$(boogie_coco_ebnf): $(coco) $(boogie_atg) frames/Parser.frame frames/Scanner.frame
	$(coco) $(boogie_atg) -genRREBNF -frames frames -o $(b)
	mv $(b)/Parser.ebnf $@

boogie_patched_ebnf = $(b)/coco.ebnf
$(boogie_patched_ebnf): boogie.ebnf.diff $(boogie_coco_ebnf)
	patch --verbose --merge --output $@ -i $< $(boogie_coco_ebnf)

boogie_ts_ebnf = $(b)/boogie.ebnf
$(boogie_ts_ebnf): tools/coco-ebnf-to-ts-ebnf.sh $(boogie_patched_ebnf)
	./$< $(boogie_patched_ebnf) $@

grammar_js = $(b)/grammar.js
$(grammar_js): tools/postprocess-grammar-js.sh $(parse_grammar) $(boogie_ts_ebnf)
	$(parse_grammar) -o $(b)/grammar.js.orig $(boogie_ts_ebnf)
	./$< $(b)/grammar.js.orig $@

# ===== RAILROAD DIAGRAM FILES =====

rr_ebnf = $(b)/rr.ebnf
$(rr_ebnf): tools/coco-ebnf-to-rr-ebnf.sh $(boogie_coco_ebnf)
	./$< < $(boogie_coco_ebnf) > $@

rr_zip = $(b)/rr.zip
$(rr_zip): $(rr_jar) $(rr_ebnf)
	java -jar $(rr_jar) -html -noembedded -out:$@ $(rr_ebnf)

# ===== PUBLIC TARGETS =====

force: $(grammar_js) $(boogie_ts_ebnf)
	cp -v $^ .

rr: $(rr_zip)
	rm -rf $@ && mkdir $@ && unzip $< -d $@

boogie.ebnf.diff:  # should be used with -B / --always-make
	diff -u $(boogie_coco_ebnf) $(boogie_patched_ebnf) > $@ ; if [ $$? -gt 1 ]; then false; fi

tree-sitter-boogie.tar.gz: docs
	set -x; d=`mktemp -d`/tree-sitter-boogie && cp -r docs "$$d" && tar -C "$$d"/.. -caf $@ tree-sitter-boogie

docs: src/parser.c rr playground
	rm -rf $@ && mkdir $@ && mkdir -p queries
	cp -rv *.md rr playground LICENSE *.ebnf *.js *.wasm src queries $@

test-boogie: src/parser.c $(boogie_atg)
	find $(b)/boogie -name '*.bpl' > $(b)/bpls
	tree-sitter parse --paths $(b)/bpls --quiet --stat

include Makefile.treesitter
