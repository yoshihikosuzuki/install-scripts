#!/bin/bash
module purge
set -eu
set -x

MODROOT=/lustre12/home/yoshihiko_s-pg/app
APP=lmod
VER=9.0.4

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

LUA_DIR=${APPDIR}/lua
LUA_VER=5.4.8
LUAROCKS_VER=3.12.2

## Lua
wget -O - https://www.lua.org/ftp/lua-${LUA_VER}.tar.gz | tar zxvf -
cd lua-${LUA_VER}
make
make install INSTALL_TOP=${LUA_DIR}
cd ..

## LuaRocks
wget -O - https://luarocks.org/releases/luarocks-${LUAROCKS_VER}.tar.gz | tar zxvf -
cd luarocks-${LUAROCKS_VER}
./configure \
    --prefix=${LUA_DIR} \
    --with-lua=${LUA_DIR}
make
make install
cd ..

## luaposix
${LUA_DIR}/bin/luarocks install luaposix --tree=${LUA_DIR}

## Lmod
wget -O - https://github.com/TACC/Lmod/archive/refs/tags/${VER}.tar.gz | tar zxvf -
cd Lmod-${VER}
## NOTE: TCL_PARENT=$(dirname $TCL_DIR) -> TCL_PARENT=$(dirname $TCL_DIR)/lib
##       in proj_mgmt/find_tcl_pc.sh for significant speed up.
sed -i 's|TCL_PARENT=$(dirname $TCL_DIR)|TCL_PARENT=$(dirname $TCL_DIR)/lib|g' proj_mgmt/find_tcl_pc.sh
eval "$(${LUA_DIR}/bin/luarocks path)"
./configure \
    --prefix=${MODROOT} \
    --with-lua_include=${LUA_DIR}/include/ \
    --with-lua=${LUA_DIR}/bin/lua \
    --with-luac=${LUA_DIR}/bin/luac
make install
cd ..

rm -rf lua-${LUA_VER} luarocks-${LUAROCKS_VER} Lmod-${VER}

## NOTE: To activate the installed Lmod, 
##       run `$ source ${APPDIR}/${VER}/init/bash` (in `$HOME/.bashrc`).
