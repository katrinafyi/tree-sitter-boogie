# tree-sitter-boogie

This is a Tree-sitter grammar for
[the Boogie intermediate verification language](https://boogie-docs.readthedocs.io/en/latest/)
([Github](https://github.com/boogie-org/boogie)).
The source code is available [on Github](https://github.com/katrinafyi/tree-sitter-boogie).

The Tree-sitter grammar is derived [from BoogiePL.atg][] in the Boogie source code. This is a
Coco/R parser generator grammar which is used in the real Boogie parser. The ATG file
is passed through [mingodad/CocoR-CPP][] which produces an EBNF grammar
([forked](https://github.com/rina-forks/CocoR-CPP) to emit EBNF for non-literal terminals).
The EBNF is run through
[tree-sitter-ebnf-generator](https://github.com/eatkins/tree-sitter-ebnf-generator)
(with some [scripted](https://github.com/katrinafyi/tree-sitter-boogie/blob/main/fix-ebnf.sh) pre-processing)
to produce an initial Tree-sitter grammar.
The Tree-sitter grammar is transformed with [fix-grammar.sh](https://github.com/katrinafyi/tree-sitter-boogie/blob/main/fix-grammar.sh) to overload some functions with regex-aware smart constructors,
then a manually-created [patch](https://github.com/katrinafyi/tree-sitter-boogie/blob/main/fix-grammar.diff)
is applied to fix some last remaining problems.

The whole pipeline is defined in the Makefile and meson.build.
If you want to reproduce the steps, this should be enough:
```bash
make force
```
The Makefile automatically configures and invokes meson+ninja.
You will need a C++ compiler, Meson 1.3.0+, Ninja, Lua 5.4 (5.4 is important for reproducibility!), and patch.

[from BoogiePL.atg]: https://github.com/boogie-org/boogie/blob/master/Source/Core/BoogiePL.atg
[mingodad/CocoR-CPP]: https://github.com/mingodad/CocoR-CPP

## railroad diagram

You can view [a railroad diagram for Boogie's EBNF grammar](https://katrinafyi.github.io/tree-sitter-boogie/rr/).

The railroad diagram is generated from the initial EBNF, so it is an accurate
representation of the official BoogiePL.atg. However, Tree-sitter grammar may
differ slightly because of the applied patches.

<a href="https://katrinafyi.github.io/tree-sitter-boogie/rr/">
<img border="0" src="https://katrinafyi.github.io/tree-sitter-boogie/rr/diagram/BoogiePL.svg" height="553" width="495">
</a>

To generate the railroad diagram locally, you can use:
```bash
make rr/index.html
```
This needs Java and it uses [Gunther Rademacher's Railroad Diagram Generator](https://www.bottlecaps.de/rr/ui).

## notes

The upstream grammar is written in a style with left-recursion removed and
precedence made explicit through rules. This is good for LL recursive-descent parsers,
but bad for Tree-sitter's AST. It leads to deeply nested structures for simple
terms because it has to descend through the precedence hierarchy.
For example,
```bash
tree-sitter generate && echo 'function f() returns (bool) { true }' | tree-sitter parse  --cst
```
leads to
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
This may or may not be a problem for practical uses of the grammar.

This project is not to be confused with
[tree-sitter-groovy](https://github.com/murtaza64/tree-sitter-groovy).

