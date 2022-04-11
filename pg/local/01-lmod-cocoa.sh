#!/bin/bash
# NOTE: Run this script on **cocoa**
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

D_DIR=$HOME/pg_transit

mkdir -p ${D_DIR}
cd ${D_DIR}

wget https://ftp.jaist.ac.jp/pub/GNU/gmp/gmp-5.0.0.tar.gz
wget https://ftp.jaist.ac.jp/pub/GNU/mpfr/mpfr-2.4.0.tar.gz
wget https://sourceforge.net/projects/lmod/files/lua-5.1.4.9.tar.bz2
wget https://sourceforge.net/projects/lmod/files/Lmod-8.6.tar.bz2
