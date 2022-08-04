#!/bin/bash

mkdir -p $HOME/.local
cd $HOME/.local

mkdir lmod
cd lmod
wget --no-check-certificate https://sourceforge.net/projects/lmod/files/lua-5.1.4.9.tar.bz2
wget --no-check-certificate https://sourceforge.net/projects/lmod/files/Lmod-8.6.tar.bz2

tar jxvf lua-5.1.4.9.tar.bz2
cd lua-5.1.4.9
mkdir install
./configure --prefix=$(readlink -f ./install)
make
make install
cd ..

tar jxvf Lmod-8.6.tar.bz2
cd Lmod-8.6
./configure --prefix=$HOME/.local --with-lua_include=$HOME/.local/lmod/lua-5.1.4.9/install/include/ --with-lua=$HOME/.local/lmod/lua-5.1.4.9/install/bin/lua --with-luac=$HOME/.local/lmod/lua-5.1.4.9/install/bin/luac
make install

# NOTE: To activate the installed Lmod, run `$ source /home/g57015/.local/lmod/lmod/init/bash` (Or add this to `$HOME/.bashrc`).
