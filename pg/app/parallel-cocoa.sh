#!/bin/bash
set -eux

D_DIR=$HOME/pg_transit
PG_DIR=$HOME/tmp

mkdir -p ${D_DIR}
cd ${D_DIR}

APP=parallel
VER=20210622

wget https://ftp.gnu.org/gnu/parallel/$APP-$VER.tar.bz2
scp $APP-$VER.tar.bz2 pg:${PG_DIR}
