#!/bin/bash -eu

url="$1"
unpack="$2"
strip_leading="$3"
out="$4"
shift 4

cache="cache/$(echo "$url" | sha256sum | cut -d' ' -f1)"

mkdir -p "$cache"
cd "$cache"

wget -nv -N "$url"

d="$(mktemp -d)"

if "$unpack"; then
  python3 -c '
  import sys, os, shutil
  shutil.unpack_archive(sys.argv[1], sys.argv[2])
  ' * "$d"
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
