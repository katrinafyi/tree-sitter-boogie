#!/bin/bash -e

mkdir -p build
cat > build/test.bpl
boogie build/test.bpl /proverLog:build/test.log
cat build/test.log


