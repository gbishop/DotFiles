#!/bin/bash

set -e
set -x

VERSION=2.2

DEST=$1
mkdir -p $DEST
cd /tmux
wget -O tmux-$VERSION.tar.gz https://github.com/tmux/tmux/releases/download/$VERSION/tmux-$VERSION.tar.gz
tar xzvf tmux-$VERSION.tar.gz
cd tmux-$VERSION

LDFLAGS="-static -static-libgcc" LIBS="-ltinfo" ./configure --enable-static --prefix=$DEST
LDFLAGS="-static -static-libgcc" make install

cp -a $DEST/* /dest
