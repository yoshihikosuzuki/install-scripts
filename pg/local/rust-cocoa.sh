#!/bin/bash
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

D_DIR=$HOME/pg_transit
PG_DIR=$HOME/tmp

mkdir -p ${D_DIR}
cd ${D_DIR}

wget https://static.rust-lang.org/dist/rust-1.60.0-x86_64-unknown-linux-gnu.tar.gz
scp rust-1.60.0-x86_64-unknown-linux-gnu.tar.gz pg:${PG_DIR}
