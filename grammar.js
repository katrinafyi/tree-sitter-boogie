/**
 * @file Tree-sitter grammar for the Boogie IVL
 * @author Kait Lam
 * @license MIT
 */

/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

module.exports = grammar({
  name: "boogie",

  rules: {
    // TODO: add the actual grammar rules
    source_file: $ => "hello"
  }
});
