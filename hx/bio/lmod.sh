#!/bin/bash

# NOTE: Run the commands below on **hx03** of pg (NOT on a CentOS 7 node) in an interactive shell
sudo su bio -
. /etc/profile
cd /bio/package
mkdir lmod
cd lmod
wget --no-check-certificate https://sourceforge.net/projects/lmod/files/lua-5.1.4.9.tar.bz2
wget --no-check-certificate https://sourceforge.net/projects/lmod/files/Lmod-8.6.tar.bz2

tar jxvf lua-5.1.4.9.tar.bz2
cd lua-5.1.4.9
mkdir install
CC=/bio/package/gcc/gcc9/bin/gcc ./configure --prefix=$(readlink -f ./install)
make
make install
cd ..

tar jxvf Lmod-8.6.tar.bz2
cd Lmod-8.6
./configure --prefix=/bio --with-lua_include=/bio/package/lmod/lua-5.1.4.9/install/include/ --with-lua=/bio/package/lmod/lua-5.1.4.9/install/bin/lua --with-luac=/bio/package/lmod/lua-5.1.4.9/install/bin/luac
make install


# NOTE: To activate the installed Lmod, run `$ source /bio/lmod/lmod/init/bash` (Or add this to `$HOME/.bashrc`).
