#!/bin/bash -eu

: $url $unpack $strip_leading $out
shift 4

cache=".fetchcache/$(echo "$url" | sha256sum | cut -d' ' -f1)"

mkdir -p "$cache"
cd "$cache"

wget -nc -N "$url"

d="$(mktemp -d)"

if "$unpack"; then
  python3 - * "$d" <<EOF
import sys, os, shutil
shutil.unpack_archive(sys.argv[1], sys.argv[2])
EOF
else
  cp -v * "$d"
fi

cd "$d"
if "$strip_leading"; then
  cd *
fi

cp -r . "$out"

# for f in "$@"; do
#   mkdir -p "$(dirname "$out/$f")"
#   cp -rv "$f" "$out/$f"
# done

rm -rf "$d"
