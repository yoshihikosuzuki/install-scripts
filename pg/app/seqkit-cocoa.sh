#!/bin/bash
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

D_DIR=$HOME/pg_transit
PG_DIR=$HOME/tmp

mkdir -p ${D_DIR}
cd ${D_DIR}

APP=seqkit
VER=2.0.0

wget https://github.com/shenwei356/seqkit/releases/download/v$VER/seqkit_linux_amd64.tar.gz
scp seqkit_linux_amd64.tar.gz pg:${PG_DIR}
