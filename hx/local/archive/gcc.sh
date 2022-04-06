#!/bin/bash
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

W_DIR=$HOME/tmp
I_DIR=$HOME/.local
N_THREAD=12
VER=10.2.0

mkdir -p ${W_DIR} ${I_DIR}
cd ${W_DIR}

wget -O - https://ftp.jaist.ac.jp/pub/GNU/gcc/gcc-${VER}/gcc-${VER}.tar.gz | tar xzvf -
B_DIR=gcc-${VER}-build
mkdir -p ${B_DIR}
cd ${B_DIR}
unset LIBRARY_PATH
../gcc-${VER}/configure --prefix=${I_DIR}/gcc/${VER} --enable-languages=c,c++ --disable-bootstrap --disable-multilib
make -j${N_THREAD} all-gcc && make install-gcc
make -j${N_THREAD} all-target-libgcc && make install-target-libgcc
cd ..
