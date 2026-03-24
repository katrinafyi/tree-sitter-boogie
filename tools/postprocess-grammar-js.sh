#!/bin/bash -eu
set -o pipefail

exec <$1 >$2

cat <<EOF
/**
	* @file Tree-sitter grammar for the Boogie IVL
	* @author Kait Lam
	* @license MPL-2.0
	*/

/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

const regexseq = (...args) => new RegExp("(?:" + args.map(x => x.source).join("") + ")");
const regexrepeat = (arg) => new RegExp("(?:" + arg.source + ")*");
const regexchoice = (...args) => new RegExp("(?:" + args.map(x => x.source).join("|") + ")");
const regexoptional = arg => new RegExp("(?:" + arg.source + ")?");

// In the vast majority of cases, the Boogie grammar is unambiguous and explicit,
// so these precedences won't get used. HOWEVER, they DO get used in the presence
// of "if-then-else" expressions to resolve conflicts between ITE and other infix
// operators.
//
// For "if-then-else" expressions, the ITE is matched in AtomExpression, so the ITE
// will be in the "_"-prefixed case. Specifying the EquivExpression as stronger
// than _EquivExpression (for example) means that the <==> has stronger precedence
// then ITE, so
//
//     if true then x else y <==> z
//
// is parsed as
//
//     if true then x else (y <==> z).
//
// Note that the rule without "_" is the real case (e.g., EquivExpression always has
// at least one <==> operator), and the one with "_" is an EquivExpression or anything
// with *stronger* precedence.
const precedences_for_ite = $ => [
  [$.EquivExpression, $._EquivExpression],
  [$.ImpliesExpression, $._ImpliesExpression],
  [$.LogicalExpression, $._LogicalExpression],
  [$.RelationalExpression, $._RelationalExpression],
  [$.BvTerm, $._BvTerm],
  [$.Term, $._Term],
  [$.Factor, $._Factor],
  [$.Power, $._Power],
  [$.IsConstructor, $._IsConstructor],
  [$.UnaryExpression, $._UnaryExpression],
  [$.CoercionExpression, $._CoercionExpression],
  [$.ArrayExpression, $._ArrayExpression],
];

// In addition to the above rules which disambiguate an expression with an ITE,
// we must also disambiguate between *multiple* infix repetitions. Again,
// this is usually enforced by the grammar structure, so the ambiguity only arises
// in the presence of ITE (and these are the only cases we must disambiguate).
// We want to disambiguate the sentence
//
//     if true then false else x <==> y <==> z
//
// so that it gets parsed as
//
//     if true then false else (x <==> y <==> z)
//
// and NOT
//
//     (if true then false else (x <==> y)) <==> z.
//
// This is unlike the earlier ambiguity, because here we are already in the
// EquivExpression rule. We just have to decide when to terminate the EquivExpression,
// and this is a matter of associativity.
//
// To get the associativity we want, where ITEs are right associative, we insert
// \`prec.right\` around the production for rules which may appear infix.

EOF

sed -e '
  /ident:/,$ {
    s/seq(/regexseq(/g
    s/repeat(/regexrepeat(/g
    s/choice(/regexchoice(/g
    s/optional(/regexoptional(/g
  }
' -e '
  /name:/a\\n  \/\/ See comments above.\n  precedences: precedences_for_ite,
' \
  | sed 's/ \+$//g'
