#!/bin/bash
set -eux

D_DIR=$HOME/pg_transit
PG_DIR=$HOME/tmp

mkdir -p ${D_DIR}
cd ${D_DIR}

APP=perl
VER=5.34.1

wget https://www.cpan.org/src/5.0/perl-$VER.tar.gz
scp perl-$VER.tar.gz pg:${PG_DIR}
