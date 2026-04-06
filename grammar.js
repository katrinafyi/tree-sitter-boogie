module.exports = grammar({
  name: "grammar_details_md",
  rules: {
    letter: ($) =>
      new RustRegex("[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]"),
    digit: ($) => new RustRegex("[0123456789]"),
    posDigit: ($) => new RustRegex("[123456789]"),
    posDigitFrom2: ($) => new RustRegex("[23456789]"),
    hexdigit: ($) => new RustRegex("[0123456789ABCDEFabcdef]"),
    special: ($) => new RustRegex("['_?]"),
    cr: ($) => new RustRegex("[\\r]"),
    lf: ($) => new RustRegex("[\\n]"),
    tab: ($) => new RustRegex("[\\t]"),
    space: ($) => new RustRegex("[ ]"),
    nondigitIdChar: ($) =>
      new RustRegex(
        "[[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]['_?]]",
      ),
    idchar: ($) =>
      new RustRegex(
        "[[[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]['_?]][0123456789]]",
      ),
    nonidchar: ($) =>
      new RustRegex(
        "[[\\s\\S]&&[^[[[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]['_?]][0123456789]]]]",
      ),
    charChar: ($) =>
      new RustRegex("[[[[[\\s\\S]&&[^[\\]]]&&[^[\\\\]]]&&[^[\\r]]]&&[^[\\n]]]"),
    stringChar: ($) =>
      new RustRegex('[[[[[\\s\\S]&&[^["]]]&&[^[\\\\]]]&&[^[\\r]]]&&[^[\\n]]]'),
    verbatimStringChar: ($) => new RustRegex('[[\\s\\S]&&[^["]]]'),
    reservedword: ($) =>
      choice(
        choice(
          choice(
            choice(
              choice(
                choice(
                  choice(
                    choice(
                      choice(
                        choice(
                          choice(
                            choice(
                              choice(
                                choice(
                                  choice(
                                    choice(
                                      choice(
                                        choice(
                                          choice(
                                            choice(
                                              choice(
                                                choice(
                                                  choice(
                                                    choice(
                                                      choice(
                                                        choice(
                                                          choice(
                                                            choice(
                                                              seq(
                                                                choice(
                                                                  choice(
                                                                    choice(
                                                                      choice(
                                                                        choice(
                                                                          choice(
                                                                            choice(
                                                                              choice(
                                                                                choice(
                                                                                  choice(
                                                                                    choice(
                                                                                      choice(
                                                                                        choice(
                                                                                          choice(
                                                                                            choice(
                                                                                              choice(
                                                                                                choice(
                                                                                                  choice(
                                                                                                    choice(
                                                                                                      choice(
                                                                                                        choice(
                                                                                                          choice(
                                                                                                            choice(
                                                                                                              choice(
                                                                                                                choice(
                                                                                                                  choice(
                                                                                                                    choice(
                                                                                                                      choice(
                                                                                                                        choice(
                                                                                                                          choice(
                                                                                                                            choice(
                                                                                                                              choice(
                                                                                                                                choice(
                                                                                                                                  choice(
                                                                                                                                    choice(
                                                                                                                                      choice(
                                                                                                                                        choice(
                                                                                                                                          choice(
                                                                                                                                            choice(
                                                                                                                                              choice(
                                                                                                                                                choice(
                                                                                                                                                  choice(
                                                                                                                                                    choice(
                                                                                                                                                      choice(
                                                                                                                                                        choice(
                                                                                                                                                          choice(
                                                                                                                                                            choice(
                                                                                                                                                              choice(
                                                                                                                                                                choice(
                                                                                                                                                                  choice(
                                                                                                                                                                    choice(
                                                                                                                                                                      choice(
                                                                                                                                                                        choice(
                                                                                                                                                                          choice(
                                                                                                                                                                            choice(
                                                                                                                                                                              choice(
                                                                                                                                                                                choice(
                                                                                                                                                                                  choice(
                                                                                                                                                                                    choice(
                                                                                                                                                                                      choice(
                                                                                                                                                                                        choice(
                                                                                                                                                                                          "abstract",
                                                                                                                                                                                          "allocated",
                                                                                                                                                                                        ),
                                                                                                                                                                                        "as",
                                                                                                                                                                                      ),
                                                                                                                                                                                      "assert",
                                                                                                                                                                                    ),
                                                                                                                                                                                    "assume",
                                                                                                                                                                                  ),
                                                                                                                                                                                  "bool",
                                                                                                                                                                                ),
                                                                                                                                                                                "break",
                                                                                                                                                                              ),
                                                                                                                                                                              "by",
                                                                                                                                                                            ),
                                                                                                                                                                            "calc",
                                                                                                                                                                          ),
                                                                                                                                                                          "case",
                                                                                                                                                                        ),
                                                                                                                                                                        "char",
                                                                                                                                                                      ),
                                                                                                                                                                      "class",
                                                                                                                                                                    ),
                                                                                                                                                                    "codatatype",
                                                                                                                                                                  ),
                                                                                                                                                                  "const",
                                                                                                                                                                ),
                                                                                                                                                                "constructor",
                                                                                                                                                              ),
                                                                                                                                                              "continue",
                                                                                                                                                            ),
                                                                                                                                                            "datatype",
                                                                                                                                                          ),
                                                                                                                                                          "decreases",
                                                                                                                                                        ),
                                                                                                                                                        "else",
                                                                                                                                                      ),
                                                                                                                                                      "ensures",
                                                                                                                                                    ),
                                                                                                                                                    "exists",
                                                                                                                                                  ),
                                                                                                                                                  "expect",
                                                                                                                                                ),
                                                                                                                                                "export",
                                                                                                                                              ),
                                                                                                                                              "extends",
                                                                                                                                            ),
                                                                                                                                            "false",
                                                                                                                                          ),
                                                                                                                                          "for",
                                                                                                                                        ),
                                                                                                                                        "forall",
                                                                                                                                      ),
                                                                                                                                      "fp32",
                                                                                                                                    ),
                                                                                                                                    "fp64",
                                                                                                                                  ),
                                                                                                                                  "fresh",
                                                                                                                                ),
                                                                                                                                "function",
                                                                                                                              ),
                                                                                                                              "ghost",
                                                                                                                            ),
                                                                                                                            "if",
                                                                                                                          ),
                                                                                                                          "imap",
                                                                                                                        ),
                                                                                                                        "import",
                                                                                                                      ),
                                                                                                                      "in",
                                                                                                                    ),
                                                                                                                    "include",
                                                                                                                  ),
                                                                                                                  "int",
                                                                                                                ),
                                                                                                                "invariant",
                                                                                                              ),
                                                                                                              "is",
                                                                                                            ),
                                                                                                            "iset",
                                                                                                          ),
                                                                                                          "iterator",
                                                                                                        ),
                                                                                                        "label",
                                                                                                      ),
                                                                                                      "lemma",
                                                                                                    ),
                                                                                                    "map",
                                                                                                  ),
                                                                                                  "match",
                                                                                                ),
                                                                                                "method",
                                                                                              ),
                                                                                              "modifies",
                                                                                            ),
                                                                                            "modify",
                                                                                          ),
                                                                                          "module",
                                                                                        ),
                                                                                        "multiset",
                                                                                      ),
                                                                                      "nameonly",
                                                                                    ),
                                                                                    "nat",
                                                                                  ),
                                                                                  "new",
                                                                                ),
                                                                                "newtype",
                                                                              ),
                                                                              "null",
                                                                            ),
                                                                            "object",
                                                                          ),
                                                                          "object?",
                                                                        ),
                                                                        "old",
                                                                      ),
                                                                      "opaque",
                                                                    ),
                                                                    "opened",
                                                                  ),
                                                                  "ORDINAL",
                                                                ),
                                                                "predicate",
                                                              ),
                                                              "print",
                                                            ),
                                                            "provides",
                                                          ),
                                                          "reads",
                                                        ),
                                                        "real",
                                                      ),
                                                      "refines",
                                                    ),
                                                    "requires",
                                                  ),
                                                  "return",
                                                ),
                                                "returns",
                                              ),
                                              "reveal",
                                            ),
                                            "reveals",
                                          ),
                                          "seq",
                                        ),
                                        "set",
                                      ),
                                      "static",
                                    ),
                                    "string",
                                  ),
                                  "then",
                                ),
                                "this",
                              ),
                              "trait",
                            ),
                            "true",
                          ),
                          "twostate",
                        ),
                        "type",
                      ),
                      "unchanged",
                    ),
                    "var",
                  ),
                  "while",
                ),
                "witness",
              ),
              "yield",
            ),
            "yields",
          ),
          $.arrayToken,
        ),
        $.bvToken,
      ),
    arrayToken: ($) =>
      seq(
        seq(
          "array",
          optional(
            seq(
              seq(choice($.posDigitFrom2, $.posDigit), $.digit),
              repeat($.digit),
            ),
          ),
        ),
        optional("?"),
      ),
    bvToken: ($) => seq("bv", seq(choice("0", $.posDigit), repeat($.digit))),
    ident: ($) => seq($.nondigitIdChar, repeat($.idchar)),
    digits: ($) => seq($.digit, repeat(seq(optional("_"), $.digit))),
    hexdigits: ($) =>
      seq(seq("0x", $.hexdigit), repeat(seq(optional("_"), $.hexdigit))),
    realnumber: ($) =>
      seq(
        seq($.digit, repeat(seq(optional("_"), $.digit))),
        seq(
          seq(
            seq(
              choice(
                seq(
                  seq(seq(".", $.digit), repeat(seq(optional("_"), $.digit))),
                  optional(
                    seq(
                      seq(seq("e", optional("-")), $.digit),
                      repeat(seq(optional("_"), $.digit)),
                    ),
                  ),
                ),
                "e",
              ),
              optional("-"),
            ),
            $.digit,
          ),
          repeat(seq(optional("_"), $.digit)),
        ),
      ),
    escapedChar: ($) =>
      seq(
        seq(
          seq(
            choice(
              seq(
                seq(
                  seq(
                    seq(
                      choice(
                        choice(
                          choice(
                            choice(
                              choice(
                                choice(choice("\\'", "\\"), "\\\\"),
                                "\\0",
                              ),
                              "\\n",
                            ),
                            "\\r",
                          ),
                          "\\t",
                        ),
                        "\\u",
                      ),
                      $.hexdigit,
                    ),
                    $.hexdigit,
                  ),
                  $.hexdigit,
                ),
                $.hexdigit,
              ),
              "\\U{",
            ),
            $.hexdigit,
          ),
          repeat($.hexdigit),
        ),
        "}",
      ),
    charToken: ($) => seq(seq("'", choice($.charChar, $.escapedChar)), "'"),
    stringToken: ($) =>
      seq(
        seq(
          seq(
            choice(
              seq(seq('"', repeat(choice($.stringChar, $.escapedChar))), '"'),
              "@",
            ),
            '"',
          ),
          repeat(seq(choice($.verbatimStringChar, '"'), '"')),
        ),
        '"',
      ),
    ellipsis: ($) => "...",
  },
});
