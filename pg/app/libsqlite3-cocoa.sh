#!/bin/bash
set -eux

D_DIR=$HOME/pg_transit
PG_DIR=$HOME/tmp

mkdir -p ${D_DIR}
cd ${D_DIR}

APP=libsqlite3
VER=3380500

wget --no-check-certificate https://www.sqlite.org/2022/sqlite-autoconf-$VER.tar.gz
scp sqlite-autoconf-$VER.tar.gz pg:${PG_DIR}
