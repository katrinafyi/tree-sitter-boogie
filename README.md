# tree-sitter-boogie

This is a Tree-sitter grammar for
[the Boogie intermediate verification language](https://boogie-docs.readthedocs.io/en/latest/)
([Github](https://github.com/boogie-org/boogie)).
The repository for this grammar is available [on Github](https://github.com/katrinafyi/tree-sitter-boogie).

## usage

(PAC users may refer to [the bincaml guide](https://uq-pac.github.io/bincaml/bincaml/tooling.html), but
applied to this boogie grammar instead of basilir.)

See your own editor's instructions for installing Tree-sitter grammars. Note that this repository
has a grammar.js but *doesn't* commit parser.c or grammar.json. If your editor needs those extra files,
you should generate them locally using the tree-sitter CLI. If that is not possible,
they are also available on Github Pages - for instance, [parser.c][] and [grammar.json][].
A combined tarball is also available: [tree-sitter-boogie.tar.gz][].

[parser.c]: https://katrinafyi.github.io/tree-sitter-boogie/src/parser.c
[grammar.json]: https://katrinafyi.github.io/tree-sitter-boogie/src/grammar.json
[tree-sitter-boogie.tar.gz]: https://katrinafyi.github.io/tree-sitter-boogie/tree-sitter-boogie.tar.gz

For testing the grammar, you can use `tree-sitter parse` or `tree-sitter highlight` while
in the repository's folder. Also see [the playground](#playground).

## highlighting example

<img width="622" height="476" alt="image" src="https://github.com/user-attachments/assets/1f648ac8-0e47-472e-b135-954cc3b583bd" />

## playground

A playground for trying out the grammar [is available here](https://katrinafyi.github.io/tree-sitter-boogie/playground/).

Here's some Boogie syntax to try out:
```boogie
var {:extern} stack_5: [bv64]bv8;
axiom ($_IO_stdin_used_addr == 1944bv64);

function {:extern} L(index: bv64) returns (bool) {
  false
}

function {:extern} {:bvbuiltin "bvadd"} bvadd64(bv64, bv64) returns (bv64);

procedure {:extern} guarantee_reflexive();
  modifies Gamma_mem_1, Gamma_mem_2, Gamma_mem_3, Gamma_mem_4, mem_1, mem_2, mem_3, mem_4;
```

## railroad diagram

You can view [a railroad diagram for Boogie's EBNF grammar](https://katrinafyi.github.io/tree-sitter-boogie/rr/).

The railroad diagram is generated from the initial EBNF, so it is an accurate
representation of the official BoogiePL.atg. However, the Tree-sitter grammar may
differ slightly because of the applied patches.

<a href="https://katrinafyi.github.io/tree-sitter-boogie/rr/">
<img border="0" src="https://katrinafyi.github.io/tree-sitter-boogie/rr/diagram/BoogiePL.svg" height="553" width="495">
</a>

To generate the railroad diagram locally, you can use:
```bash
make rr
```
This needs Java and it uses [Gunther Rademacher's Railroad Diagram Generator](https://www.bottlecaps.de/rr/ui).

## development

The Tree-sitter grammar is derived [from BoogiePL.atg][] in the Boogie source code. This is a
Coco/R parser generator grammar which is used in the actual Boogie parser. The ATG file
is passed through [mingodad/CocoR-CPP][] which produces an EBNF grammar
([forked](https://github.com/rina-forks/CocoR-CPP) to emit EBNF for non-literal terminals).
The EBNF is [pre-processed](https://github.com/katrinafyi/tree-sitter-boogie/blob/main/tools/coco-ebnf-to-ts-ebnf.sh)
to adjust some syntax and [a manually-created patch](https://github.com/katrinafyi/tree-sitter-boogie/blob/main/boogie.ebnf.diff)
is applied to fix some things which are difficult for Tree-sitter.
Then, the patched EBNF is run through
[tree-sitter-ebnf-generator](https://github.com/eatkins/tree-sitter-ebnf-generator)
to produce an initial Tree-sitter grammar, and
the Tree-sitter grammar is transformed with
[postprocess-grammar-js.sh](https://github.com/katrinafyi/tree-sitter-boogie/blob/main/tools/postprocess-grammar-js.sh)
to overload some functions with regex-aware smart constructors.

The generation pipeline is defined in the Makefile. If you want to reproduce the
steps, you will need a C++ compiler, wget, patch, and Lua 5.4 (5.4 is important for reproducibility!).
With the dependencies available, this should be enough:
```bash
make force
```
`make force` will rebuild the grammar.js and it should be identical to the one
already in this repository. If not, then that is a bug :)

To run the tests, you can use
```bash
make test
make test-boogie
```
The first command uses Tree-sitter corpus tests in test/corpus, and the second runs the parser
on Boogie's own unit test files and reports the percent successful.

[from BoogiePL.atg]: https://github.com/boogie-org/boogie/blob/master/Source/Core/BoogiePL.atg
[mingodad/CocoR-CPP]: https://github.com/mingodad/CocoR-CPP

## testing

There are a small number of hand-written tests in the [test/corpus](https://github.com/katrinafyi/tree-sitter-boogie/tree/main/test/corpus)
directory. These focus on parts of the grammar which we have changed from BoogiePL.atg
(like if-then-else), or which we needed to manually implement (like comments).

You can also run the parser against the Boogie files in the upstream repository
with
```bash
make test-boogie
```
At time of writing, the Tree-sitter grammar successfully parses all the syntactically
valid test files and even some of the invalid ones:
```
=== boogie test files with expected parse errors ===
tree-sitter parse --paths build/bad-bpls --quiet --stat --time
build/boogie/Test/bitvectors/bv7.bpl                    Parse:    0.18 ms         1174 bytes/ms
build/boogie/Test/datatypes/duplicate_constructor.bpl   Parse:    0.05 ms         2332 bytes/ms
build/boogie/Test/floats/ConstSyntax3.bpl               Parse:    0.36 ms         2403 bytes/ms
build/boogie/Test/floats/SpecialValues.bpl              Parse:    0.54 ms         1965 bytes/ms
build/boogie/Test/functiondefine/fundef4.bpl            Parse:    0.22 ms         1428 bytes/ms
build/boogie/Test/functiondefine/fundef8.bpl            Parse:    0.09 ms         1926 bytes/ms
build/boogie/Test/roundingmodes/InvalidFuncName.bpl     Parse:    0.04 ms         4352 bytes/ms
build/boogie/Test/roundingmodes/RMAttributeInvalid.bpl  Parse:    0.63 ms          515 bytes/ms (ERROR [3, 32] - [3, 37])
build/boogie/Test/test0/AttributeParsingErr.bpl         Parse:    0.46 ms         1427 bytes/ms
build/boogie/Test/test0/BadLabels1.bpl                  Parse:    0.62 ms         2081 bytes/ms
build/boogie/Test/test0/BadQuantifier.bpl               Parse:    0.17 ms          889 bytes/ms (ERROR [4, 7] - [4, 24])
build/boogie/Test/test0/LineParse.bpl                   Parse:    0.04 ms         9120 bytes/ms (ERROR [12, 1] - [12, 9])
build/boogie/Test/test0/Triggers0.bpl                   Parse:    0.28 ms         1677 bytes/ms
build/boogie/Test/test0/Types0.bpl                      Parse:    0.16 ms         2154 bytes/ms
build/boogie/Test/test0/WhereParsing0.bpl               Parse:    0.70 ms         1219 bytes/ms
build/boogie/Test/test0/WhereParsing1.bpl               Parse:    0.27 ms         1626 bytes/ms (ERROR [15, 26] - [15, 37])
build/boogie/Test/test0/WhereParsing2.bpl               Parse:    0.07 ms         2244 bytes/ms (ERROR [2, 13] - [2, 24])
build/boogie/Test/test0/WhereParsing.bpl                Parse:    0.70 ms         1411 bytes/ms

Total parses: 18; successful parses: 13; failed parses: 5; success percentage: 72.22%; average speed: 1609 bytes/ms

make: [Makefile:116: test-boogie] Error 1 (ignored)

=== boogie test files with expected parse success ===
tree-sitter parse --paths build/good-bpls --quiet --stat

Total parses: 723; successful parses: 723; failed parses: 0; success percentage: 100.00%; average speed: 5865 bytes/ms
```

## notes

The upstream grammar is written in a style with left-recursion removed and
precedence made explicit through rules. This is good for LL recursive-descent parsers,
but bad for Tree-sitter's AST.

We have done some work, in [ts-ebnf-fix-ll.py](https://github.com/katrinafyi/tree-sitter-boogie/blob/main/tools/ts-ebnf-fix-ll.py),
to omit these precedence hierarchies from the parsed Tree-sitter AST.

Originally, it would lead to deeply nested structures for simple
terms because it descends through the precedence hierarchy.
For example,
```bash
tree-sitter generate && echo 'function f() returns (bool) { true }' | tree-sitter parse  --cst
```
would have returned
```js
0:0  - 1:0    BoogiePL
0:0  - 0:36     Function
0:0  - 0:8        "function"
0:9  - 0:10       Ident
0:9  - 0:10         ident `f`
0:10 - 0:11       "("
0:11 - 0:12       ")"
0:13 - 0:20       "returns"
0:21 - 0:22       "("
0:22 - 0:26       VarOrType
0:22 - 0:26         Type
0:22 - 0:26           TypeAtom
0:22 - 0:26             "bool"
0:26 - 0:27       ")"
0:28 - 0:29       "{"
0:30 - 0:34       Expression
0:30 - 0:34         ImpliesExpression
0:30 - 0:34           LogicalExpression
0:30 - 0:34             RelationalExpression
0:30 - 0:34               BvTerm
0:30 - 0:34                 Term
0:30 - 0:34                   Factor
0:30 - 0:34                     Power
0:30 - 0:34                       IsConstructor
0:30 - 0:34                         UnaryExpression
0:30 - 0:34                           CoercionExpression
0:30 - 0:34                             ArrayExpression
0:30 - 0:34                               AtomExpression
0:30 - 0:34                                 "true"
0:35 - 0:36       "}"
```

After applying the fix-ll.py script, the parsed AST is much simpler:
```js
0:0  - 1:0    BoogiePL
0:0  - 0:36     Function
0:0  - 0:8        "function"
0:9  - 0:10       Ident
0:9  - 0:10         ident `f`
0:10 - 0:11       "("
0:11 - 0:12       ")"
0:13 - 0:20       "returns"
0:21 - 0:22       "("
0:22 - 0:26       VarOrType
0:22 - 0:26         Type
0:22 - 0:26           TypeAtom
0:22 - 0:26             "bool"
0:26 - 0:27       ")"
0:28 - 0:29       "{"
0:30 - 0:34       Expression
0:30 - 0:34         AtomExpression
0:30 - 0:34           "true"
0:35 - 0:36       "}"
```
This makes it easier to work with the AST for queries and highlighting.

## limitations

- Directives are not interpreted at all and all code is assumed to exist at the same time.
  If *excluding* some lines is crucial for syntax correctness, that will cause problems.
  For example, this will fail:
  ```
  axiom (
  #if true
    2)
  #else
    3)
  #endif
  ;
  ```

## related work

[boogie-vscode](https://github.com/boogie-org/boogie-vscode) is the official VSCode extension for Boogie
with a Textmate grammar for syntax highlighting, but the highlighting is fairly minimal.
This is used by [linguist](https://github.com/github-linguist/linguist/tree/main/vendor) for syntax
highlighting on Github.

This project is not to be confused with
[tree-sitter-groovy](https://github.com/murtaza64/tree-sitter-groovy).
