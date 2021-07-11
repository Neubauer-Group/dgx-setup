#!/bin/bash

export CPYTHON_VERSION=3.8.11

PYTHON_CONFIGURE_OPTS="--with-ensurepip --enable-optimizations --with-lto --enable-loadable-sqlite-extensions --enable-ipv6 --enable-shared" \
    pyenv install --force "${CPYTHON_VERSION}"

unset CPYTHON_VERSION
