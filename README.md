# tree-sitter-boogie

This is a Tree-sitter grammar for
[the Boogie intermediate verification language](https://boogie-docs.readthedocs.io/en/latest/)
([Github](https://github.com/boogie-org/boogie)).
The repository for this grammar is available [on Github](https://github.com/katrinafyi/tree-sitter-boogie).

## usage

(PAC users may refer to [the bincaml guide](https://agle.github.io/bincaml/bincaml/tooling.html), but
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

This project is not to be confused with
[tree-sitter-groovy](https://github.com/murtaza64/tree-sitter-groovy).

