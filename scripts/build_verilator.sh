#!/usr/bin/env bash
# Build and install a pinned Verilator into $HOME/opt/verilator.
# Usage: scripts/build_verilator.sh v5.052
set -euo pipefail
TAG="${1:?usage: build_verilator.sh <tag>}"
PREFIX="$HOME/opt/verilator"
SRC="$HOME/src/verilator"
unset VERILATOR_ROOT    # a stale value breaks prefix installs
if [ ! -d "$SRC/.git" ]; then
   git clone https://github.com/verilator/verilator "$SRC"
fi
cd "$SRC"
git fetch --tags
git checkout "$TAG"
autoconf
./configure --prefix="$PREFIX"
make -j"${JOBS:-$(nproc)}"
make install
"$PREFIX/bin/verilator" --version
