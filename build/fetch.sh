#!/bin/bash -eu

d="$(mktemp -d)"

cd "$d"

url="$1"
unpack="$2"
strip_leading="$3"
out="$4"
shift 4

wget -nv "$url"

if "$unpack"; then
  python3 -c '
  import sys, os, shutil
  shutil.unpack_archive(sys.argv[1])
  os.unlink(sys.argv[1])
  ' *
fi

if "$strip_leading"; then
  cd *
fi

cp -r . "$out"

# for f in "$@"; do
#   mkdir -p "$(dirname "$out/$f")"
#   cp -rv "$f" "$out/$f"
# done

rm -rf "$d"
