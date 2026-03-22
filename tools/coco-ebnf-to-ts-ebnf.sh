#!/bin/bash -eu
set -o pipefail

exec <$1 >$2

cat <<EOF
extras ::= { comment /\s+/ }

conflicts ::= { { Type } { TypeArgs } }

word ::= ident

rules:
EOF

cat \
	| sed 's_^//_;_g' \
	| sed 's/ EOF$//g' \
	| grep . \
	| sed 's/^/  /g' \
	| "$(dirname $0)/ts-ebnf-fix-ll.py"

echo '  comment ::= /\/\/.*\n/'
