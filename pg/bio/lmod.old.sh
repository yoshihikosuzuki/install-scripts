#!/bin/bash

# NOTE: Temporary directories for transferring source tarballs. Use arbitrary names.
COCOA_TMP_DIR=~/pg_transit
PG_TMP_DIR=~/tmp


# NOTE: Run the following commands on **cocoa** in an interactive shell
cd ${COCOA_TMP_DIR}
wget https://sourceforge.net/projects/lmod/files/lua-5.1.4.9.tar.bz2
wget https://sourceforge.net/projects/lmod/files/Lmod-8.6.tar.bz2
scp lua-5.1.4.9.tar.bz2 Lmod-8.6.tar.bz2 pg:${PG_TMP_DIR}


# NOTE: Run the commands below on any node of pg in an interactive shell
sudo mv ${PG_TMP_DIR}/lua-5.1.4.9.tar.bz2 ${PG_TMP_DIR}/Lmod-8.6.tar.bz2 /bio/package


# NOTE: Run the commands below on **a01** of pg (NOT on a CentOS 7 node) in an interactive shell
sudo su bio -
. /etc/profile
cd /bio/package
mkdir lmod
mv lua-5.1.4.9.tar.bz2 Lmod-8.6.tar.bz2 lmod
cd lmod

tar jxvf lua-5.1.4.9.tar.bz2
cd lua-5.1.4.9
mkdir install
./configure --prefix=$(readlink -f ./install)
make
make install
cd ..

tar jxvf Lmod-8.6.tar.bz2
cd Lmod-8.6
./configure --prefix=/bio --with-lua_include=/bio/package/lmod/lua-5.1.4.9/install/include/ --with-lua=/bio/package/lmod/lua-5.1.4.9/install/bin/lua --with-luac=/bio/package/lmod/lua-5.1.4.9/install/bin/luac
make install


# NOTE: To activate the installed Lmod, run `$ source /bio/lmod/lmod/init/bash` (Or add this to `$HOME/.bashrc`).
