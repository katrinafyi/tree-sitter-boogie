#!/bin/bash -eu
set -o pipefail

cat <<EOF
extras ::= { comment /\s+/ }

conflicts ::= { { Type } { TypeArgs } }

word ::= ident

rules:
EOF

cat \
	| sed 's_^//_;_g' \
	| sed 's_ | )_ )?_g' \
	| sed 's/ EOF//g' \
	| grep . \
	| sed 's/^/  /g'

echo '  comment ::= /\/\/.*\n/'
