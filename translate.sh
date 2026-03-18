#!/bin/bash -xe

sed 's/ {/ (/g' | \
  sed 's/ }/ )*/g' | \
  sed 's/ \[/ (/g' | \
  sed 's/ \]/ )?/g' | \
  cat


