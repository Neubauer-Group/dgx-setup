#!/bin/bash

set -o pipefail

# Enable better devtools for compiling as they're available
source scl_source enable devtoolset-9

export CPYTHON_VERSION=3.8.11

PYTHON_CONFIGURE_OPTS="--with-ensurepip --enable-optimizations --with-lto --enable-loadable-sqlite-extensions --enable-ipv6 --enable-shared" \
    PYTHON_MAKE_OPTS="-j8" \
    pyenv install --force "${CPYTHON_VERSION}"

unset CPYTHON_VERSION
