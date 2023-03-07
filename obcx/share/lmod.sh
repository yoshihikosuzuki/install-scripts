#!/bin/bash
module purge
set -eu
set -x

ROOT="/work/00/gg57/share/yoshi-tools"
LUA_VERSION=5.1.4.9
LMOD_VERSION=8.7

mkdir -p ${ROOT}
cd ${ROOT}

mkdir lmod
cd lmod
wget --no-check-certificate https://sourceforge.net/projects/lmod/files/lua-${LUA_VERSION}.tar.bz2
wget --no-check-certificate https://sourceforge.net/projects/lmod/files/Lmod-${LMOD_VERSION}.tar.bz2

tar jxvf lua-${LUA_VERSION}.tar.bz2
cd lua-${LUA_VERSION}
mkdir install
./configure --prefix=$(readlink -f ./install)
make
make install
cd ..

tar jxvf Lmod-${LMOD_VERSION}.tar.bz2
cd Lmod-${LMOD_VERSION}
./configure \
    --prefix=$ROOT \
    --with-lua_include=$ROOT/lmod/lua-${LUA_VERSION}/install/include/ \
    --with-lua=$ROOT/lmod/lua-${LUA_VERSION}/install/bin/lua \
    --with-luac=$ROOT/lmod/lua-${LUA_VERSION}/install/bin/luac
make install

# NOTE: To activate the installed Lmod, run `$ source /work/00/gg57/share/yoshi-tools/lmod/lmod/init/bash` (Or add this to `$HOME/.bashrc`).
