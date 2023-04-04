#!/bin/bash

# NOTE: Temporary directories for transferring source tarballs. Use arbitrary names.
COCOA_TMP_DIR=~/pg_transit
PG_TMP_DIR=~/tmp


# NOTE: Run the following commands on **cocoa** in an interactive shell
cd ${COCOA_TMP_DIR}
wget https://sourceforge.net/projects/lmod/files/lua-5.1.4.9.tar.bz2
wget https://sourceforge.net/projects/lmod/files/Lmod-8.6.tar.bz2
wget http://git.savannah.gnu.org/cgit/readline.git/snapshot/readline-master.tar.gz
wget https://invisible-island.net/archives/ncurses/ncurses-6.4.tar.gz
scp lua-5.1.4.9.tar.bz2 Lmod-8.6.tar.bz2 readline-master.tar.gz ncurses-6.4.tar.gz pg:${PG_TMP_DIR}


# NOTE: Run the commands below on any node of pg in an interactive shell
cd ${PG_TMP_DIR}/
sudo mv lua-5.1.4.9.tar.bz2 Lmod-8.6.tar.bz2 readline-master.tar.gz ncurses-6.4.tar.gz /bio/package


# NOTE: Run the commands below on **a01** of pg (NOT on a CentOS 7 node) in an interactive shell
sudo su bio -
. /etc/profile
cd /bio/package
mkdir lmod-new
mv lua-5.1.4.9.tar.bz2 Lmod-8.6.tar.bz2 readline-master.tar.gz ncurses-6.4.tar.gz lmod
cd lmod-new

# install libreadline (and libhistory) (maybe need `ml gcc/9.2.0`)
tar xzvf readline-master.tar.gz
cd readline-master
mkdir install
./configure --prefix=$(readlink -f ./install)
make
make install
cd ..

# install libncurses (and libtinfo)
tar xzvf ncurses-6.4.tar.gz
cd ncurses-6.4
mkdir install
./configure --prefix=$(readlink -f ./install) --with-termlib
make -i
make install
cd ..

# install lua
tar jxvf lua-5.1.4.9.tar.bz2
cd lua-5.1.4.9
mkdir install
./configure --prefix=$(readlink -f ./install) --with-static=YES
make
# It should fail at compilation of lua binary. Then, run this:
cd lua/src
gcc -o lua  lua.o liblua.a -lm -Wl,-E -ldl -Wl,-Bstatic -lhistory -lreadline -ltinfo -lncurses  -Wl,-Bdynamic -L/bio/package/lmod-new/readline-master/install/lib/ -L/bio/package/lmod-new/ncurses-6.4/install/lib/
gcc -o luac  luac.o print.o liblua.a -lm -Wl,-E -ldl -Wl,-Bstatic -lhistory -lreadline -ltinfo -lncurses  -Wl,-Bdynamic -L/bio/package/lmod-new/readline-master/install/lib/ -L/bio/package/lmod-new/ncurses-6.4/install/lib/
make install
cd ..

# install lmod
tar jxvf Lmod-8.6.tar.bz2
cd Lmod-8.6
./configure --prefix=/bio --with-lua_include=/bio/package/lmod-new/lua-5.1.4.9/install/include/ --with-lua=/bio/package/lmod-new/lua-5.1.4.9/install/bin/lua --with-luac=/bio/package/lmod-new/lua-5.1.4.9/install/bin/luac --with-tcl=no
make install


# NOTE: To activate the installed Lmod, run `$ source /bio/lmod/lmod/init/bash` (Or add this to `$HOME/.bashrc`).
