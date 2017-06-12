#!/bin/bash

set -e
set -x

cd /vim
DEST=$1
mkdir -p $DEST
LDFLAGS="-static -static-libgcc" ./configure --enable-static --prefix=$DEST --with-features=big
LDFLAGS="-static -static-libgcc" make install
cp -a $DEST/* /dest

