#!/bin/bash
set -eux

D_DIR=$HOME/pg_transit
PG_DIR=$HOME/tmp

mkdir -p ${D_DIR}
cd ${D_DIR}

APP=R
VER=4.2.0

wget --no-check-certificate https://cran.rstudio.com/src/base/R-4/R-$VER.tar.gz
scp R-$VER.tar.gz pg:${PG_DIR}
