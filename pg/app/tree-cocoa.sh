#!/bin/bash
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

D_DIR=$HOME/pg_transit
PG_DIR=$HOME/tmp

mkdir -p ${D_DIR}
cd ${D_DIR}

APP=tree
VER=2.0.2

wget https://gitlab.com/OldManProgrammer/unix-tree/-/archive/$VER/unix-tree-$VER.tar.gz
scp unix-tree-$VER.tar.gz pg:${PG_DIR}
