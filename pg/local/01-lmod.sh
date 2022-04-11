#!/bin/bash
# NOTE: Run this script on **pg**
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

W_DIR=$HOME/tmp
I_DIR=$HOME/.local
N_THREAD=12

mkdir -p ${W_DIR} ${I_DIR}
cd ${W_DIR}

# Install libgmp-5.0.0 for libgmp.so.3
tar zxvf gmp-5.0.0.tar.gz
cd gmp-5.0.0
./configure --prefix=${I_DIR}
make clean && make -j${N_THREAD} && make check -k -j${N_THREAD} && make install
cd ..

# Install libmpfr-2.4.0 for libmpfr.so.1
tar zxvf mpfr-2.4.0.tar.gz
cd mpfr-2.4.0
./configure --prefix=${I_DIR} --with-gmp=${I_DIR}
make clean && make -j${N_THREAD} && make check -k -j${N_THREAD} && make install
cd ..

# Install Lua
tar jxvf lua-5.1.4.9.tar.bz2
cd lua-5.1.4.9
./configure --prefix=${I_DIR}
make && make install
cd ..

# Install Lmod
tar jxvf Lmod-8.6.tar.bz2
cd Lmod-8.6
./configure --prefix=${I_DIR}
make install
cd ..

cat <<__END__ >>$HOME/.bashrc

# Lmod
source ${I_DIR}/lmod/lmod/init/bash
__END__

# # (Alternatively,) Install Environment Modules
# wget -O - https://github.com/cea-hpc/modules/releases/download/v4.6.1/modules-4.6.1.tar.gz | tar zxvf -
# cd modules-4.6.1
# ./configure --prefix=${I_DIR} --modulefilesdir=${I_DIR}/modulefiles
# make clean && make -j${N_THREAD} && make check -k -j${N_THREAD} && make install
# cd ..

# cat <<__END__ >>$HOME/.bashrc
# 
# # Environment Modules
# source ${I_DIR}/init/bash
# __END__
