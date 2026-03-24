#!/usr/bin/env python3
# vim: ts=2 sts=2 sw=2 et

import sys

"""
Generates a regular expression matching up to a certain depth of nested
C-style multiline comments. If the depth is exceeded, comments will be
matched naively to the next `*/` pair (likely breaking later syntax).

In this file, we name these parts of a multi-line comment:

    /* fsja */
      ^^^^^^^^-- tail (everything after the head including `*/`)
    ^^---------- head (beginning `/*` pair)

The delimiters must be non-overlapping (i.e., `/*/` is not a valid comment
and would just start a comment).
"""

def non_nested_comment_tail() -> str:
  """
  A regex matching a comment tail without considering nested comments.
  Matches naively up to and including the next `*/`.
  """
  return r'(?:[^*]|[*]+[^*/])*[*]+[/]'

def body_without_comment_delimiters() -> str:
  """
  A regex matching any number of repetitions of:
  - characters that are not `*` or `/`,
  - `*` sequences terminated by a non-`*` and non-`/` character, or
  - `/` sequences terminated by a non-`*` and non-`/` character.

  Essentially, this is the longest string which can be proven to not contain
  `*/` or `/*`, _without_ the use of lookahead. As such, the matched string will
  not end with a run of `/` or `*`.
  """
  return r'(?:[^*/]|[*]+[^*/]|[/]+[^/*])*'

def nested_comment_tail(depth: int) -> str:
  """
  Builds a regex for the *tail* of a multi-line comment with up to `depth`
  nested inner multi-line comments. Nesting is based on depth; adjacent nested
  comments at the same depth are no problem.
  """
  if depth == 0:
    return non_nested_comment_tail()
  return rf'(?:{body_without_comment_delimiters()}|[/]+[*]{nested_comment_tail(depth-1)})*[*]+[/]'

print('[/][*]' + nested_comment_tail(int(sys.argv[1])))
