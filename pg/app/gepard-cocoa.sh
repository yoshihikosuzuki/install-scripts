#!/bin/bash
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

D_DIR=$HOME/pg_transit
PG_DIR=$HOME/tmp

mkdir -p ${D_DIR}
cd ${D_DIR}

APP=gepard
VER=1.40.0

wget https://github.com/univieCUBE/$APP/archive/refs/tags/v$VER.tar.gz
scp v$VER.tar.gz pg:${PG_DIR}

VER=2.1.0

wget https://github.com/univieCUBE/$APP/archive/refs/tags/v$VER.tar.gz
scp v$VER.tar.gz pg:${PG_DIR}
