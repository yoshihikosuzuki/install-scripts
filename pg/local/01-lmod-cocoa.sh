#!/bin/bash
# NOTE: Run this script on **cocoa**
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

D_DIR=$HOME/pg_transit
PG_DIR=$HOME/tmp

mkdir -p ${D_DIR}
cd ${D_DIR}

wget https://ftp.jaist.ac.jp/pub/GNU/gmp/gmp-5.0.0.tar.gz
wget https://ftp.jaist.ac.jp/pub/GNU/mpfr/mpfr-2.4.0.tar.gz
wget https://sourceforge.net/projects/lmod/files/lua-5.1.4.9.tar.bz2
wget https://sourceforge.net/projects/lmod/files/Lmod-8.6.tar.bz2
scp gmp-5.0.0.tar.gz mpfr-2.4.0.tar.gz lua-5.1.4.9.tar.bz2 Lmod-8.6.tar.bz2 pg:${PG_DIR}
