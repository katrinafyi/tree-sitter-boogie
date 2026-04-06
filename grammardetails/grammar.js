/**
 * @file GrammarDetailsMd grammar for tree-sitter
 * @author Kait Lam
 * @license MPL-2.0
 */

/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

module.exports = grammar({
  name: "grammar_details_md",

  rules: {
    grammar: $ => choice(
      field("afield", "a"),
      field("bfield", "b"),
    ),
  }
});
