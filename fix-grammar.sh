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


EOF

sed '
  /ident:/,$ {
    s/seq(/regexseq(/g
    s/repeat(/regexrepeat(/g
    s/choice(/regexchoice(/g
    s/optional(/regexoptional(/g
  }
' \
  | sed 's/ \+$//g'
