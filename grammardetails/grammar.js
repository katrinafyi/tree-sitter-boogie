/**
 * @file GrammarDetailsMd grammar for tree-sitter
 * @author Kait Lam
 * @license MPL-2.0
 */

/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

module.exports = grammar({
  name: "grammar_details_md",

  conflicts: $ => [
    [$.terminal_sequence, $.terminal_decl]
  ],

  rules: {
    grammar: $ => repeat($.rule),
    rule: $ => choice($.terminal_decl),

    char_literal: $ =>
      token(
        seq("'",
          repeat1(
            choice(
              /[^\\']/,
              /\\./
            )
          ),
          "'")
      ),

    string_literal: $ =>
      token(
        seq('"',
          repeat(
            choice(
              /[^\\"]/,
              /\\./
            )
          ),
          '"')
      ),

    literal: $ => choice($.string_literal, $.char_literal, "ANY"),

    terminal_name: $ => /[a-z]\w*/,
    nonterminal_name: $ => /[A-Z]\w*/,
    name: $ => choice($.terminal_name, $.nonterminal_name),

    terminal_decl: $ => seq(
      $.terminal_name,
      "=",
      $.terminal_rule,
    ),

    terminal_rule: $ => choice(
      $.terminal_atom,
      $.terminal_addition,
      $.terminal_subtraction,
      $.terminal_alternation,
      $.terminal_sequence,
      seq("(", $.terminal_rule, ")"),
      seq("[", $.terminal_rule, "]"),
      seq("{", $.terminal_rule, "}"),
    ),
    terminal_atom: $ => choice(
      $.literal,
      $.terminal_name,
    ),
    terminal_addition: $ => prec.left(seq(
      $.terminal_rule, "+", $.terminal_rule
    )),
    terminal_subtraction: $ => prec.left(seq(
      $.terminal_rule, "-", $.terminal_rule
    )),
    terminal_alternation: $ => prec.left(seq(
      $.terminal_rule, "|", $.terminal_rule
    )),
    terminal_sequence: $ => prec.left(seq($.terminal_rule, $.terminal_rule)),


  }
});
