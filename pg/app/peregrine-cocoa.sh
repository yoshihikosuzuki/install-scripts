#!/bin/bash
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

D_DIR=$HOME/pg_transit
PG_DIR=$HOME/tmp

mkdir -p ${D_DIR}
cd ${D_DIR}

APP=canu
VER=2.1.1

wget https://github.com/marbl/canu/releases/download/v$VER/$APP-$VER.Linux-amd64.tar.xz
scp $APP-$VER.Linux-amd64.tar.xz pg:${PG_DIR}
