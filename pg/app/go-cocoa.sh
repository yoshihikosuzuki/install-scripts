#!/bin/bash
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

D_DIR=$HOME/pg_transit
PG_DIR=$HOME/tmp

mkdir -p ${D_DIR}
cd ${D_DIR}

APP=go
VER=1.18

wget https://go.dev/dl/go$VER.linux-amd64.tar.gz
scp go$VER.linux-amd64.tar.gz pg:${PG_DIR}
