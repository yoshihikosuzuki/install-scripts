#!/bin/bash
set -eux

D_DIR=$HOME/pg_transit
PG_DIR=$HOME/tmp

mkdir -p ${D_DIR}
cd ${D_DIR}

APP=pigz
VER=2.7

wget https://zlib.net/pigz/$APP-$VER.tar.gz
scp $APP-$VER.tar.gz pg:${PG_DIR}
