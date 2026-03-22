#!/bin/bash -e
set -o pipefail

cat \
  | sed -E 's "\\u([0-9a-f]{4})" #x\1 g' \
  | sed -E 's \\u([0-9a-f]{4}) #x\1 g'
