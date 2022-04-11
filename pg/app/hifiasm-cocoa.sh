#!/bin/bash
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

D_DIR=$HOME/pg_transit
PG_DIR=$HOME/tmp

mkdir -p ${D_DIR}
cd ${D_DIR}

APP=hifiasm
VER=0.15.4

wget https://github.com/chhylp123/hifiasm/archive/refs/tags/$VER.tar.gz
scp $VER.tar.gz pg:${PG_DIR}
