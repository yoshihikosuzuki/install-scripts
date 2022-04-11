#!/bin/bash
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

D_DIR=$HOME/pg_transit
PG_DIR=$HOME/tmp

mkdir -p ${D_DIR}
cd ${D_DIR}

APP=gfatools
VER=0.5

wget https://github.com/lh3/gfatools/archive/refs/tags/v$VER.tar.gz
scp v$VER.tar.gz pg:${PG_DIR}
