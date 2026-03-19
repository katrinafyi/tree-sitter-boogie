# tree-sitter-boogie

(Not to be confused with [tree-sitter-groovy](https://github.com/murtaza64/tree-sitter-groovy).)

This is a Tree-sitter grammar for [the Boogie intermediate verification language](https://boogie-docs.readthedocs.io/en/latest/)
([Github](https://github.com/boogie-org/boogie)).

The grammar is derived from [its EBNF grammar](https://boogie-docs.readthedocs.io/en/latest/LangRef.html#grammar),
run through [tree-sitter-ebnf-generator](https://github.com/eatkins/tree-sitter-ebnf-generator)
(with some [scripted](https://github.com/katrinafyi/tree-sitter-boogie/blob/main/translate.sh)
and manual pre-processing beforehand).

This worked surprisingly well and gave us an initial grammar.js file. The rest of the work
will be manual cleanup and fixes: for instance, rewriting token rules into proper regexes
and fixing ambiguities and inaccuracies in the grammar.

Additionally, the original EBNF was written in a style with left-recursion removed and
precedence made explicit through rules. This is good for LL parsers but bad for Tree-sitter's
AST. It leads to deeply nested structures for simple terms, because it has to descend
through the precedence hierarchy. For example,
```bash
tree-sitter generate && echo 'function f() returns (bool) { true }' | tree-sitter  parse  --cst
```
leads to
```c
0:0  - 1:0    boogie_program
0:0  - 0:36     func_decl
0:0  - 0:8        "function"
0:9  - 0:10       ident `f`
0:10 - 0:11       "("
0:11 - 0:12       ")"
0:13 - 0:20       "returns"
0:21 - 0:22       "("
0:22 - 0:26       var_or_type
0:22 - 0:26         type
0:22 - 0:26           type_atom
0:22 - 0:26             "bool"
0:26 - 0:27       ")"
0:28 - 0:29       "{"
0:30 - 0:34       expr
0:30 - 0:34         implies_expr
0:30 - 0:34           logical_expr
0:30 - 0:34             rel_expr
0:30 - 0:34               bv_term
0:30 - 0:34                 term
0:30 - 0:34                   factor
0:30 - 0:34                     power
0:30 - 0:34                       unary_expr
0:30 - 0:34                         coercion_expr
0:30 - 0:34                           array_expr
0:30 - 0:34                             atom_expr
0:30 - 0:34                               bool_lit
0:30 - 0:34                                 "true"
0:35 - 0:36       "}"
```
This may or may not be a problem for practical uses of the grammar.

