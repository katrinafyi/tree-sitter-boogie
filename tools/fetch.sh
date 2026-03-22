#!/bin/bash -eu

: $url $unpack $strip_leading $out

if $unpack; then
  mkdir -p "$out"
  pushd "$out"
  out="$(pwd)"
  popd
else
  mkdir -p "$(dirname "$out")"
fi

cache=".fetchcache/$(echo "$url" | sha256sum | cut -d' ' -f1)"

mkdir -p "$cache"

wget -nv -nc "$url" --directory-prefix "$cache"

if ! $unpack; then
  exec cp -v "$cache"/* "$out"
fi

d="$(mktemp -d)"

python3 - "$cache"/* "$d" <<EOF
import sys, os, shutil
shutil.unpack_archive(sys.argv[1], sys.argv[2])
EOF

cd "$d"
if "$strip_leading"; then
  cd *
fi

echo "$(pwd) -> $out"
cp -r . "$out"

rm -rf "$d"
