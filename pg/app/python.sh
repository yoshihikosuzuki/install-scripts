#!/bin/bash
module purge
set -eux

module use /bio/package/.modulefiles
module use /nfs/data05/yoshihiko_s/app/.modulefiles
module load gcc/9.2.0 openssl/1.1.1d libsqlite3/3380500 libffi/3.4.4

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data05/yoshihiko_s/app
APP=python
VER=3.10.14

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
git clone https://github.com/python/cpython
cd cpython
git checkout 3.10
export LDFLAGS="-Wl,-rpath=/nfs/data05/yoshihiko_s/app/libffi/3.4.4/lib64 -Wl,-rpath=/nfs/data05/yoshihiko_s/app/libsqlite3/3380500/lib $LDFLAGS"
./configure --prefix $APPDIR/$VER --with-ensurepip=install --with-openssl=$OPENSSL_PATH --enable-optimizations
make
make install
cd ..
# rm -rf cpython
chmod -w $VER/lib/python3.10/site-packages
cd $VER/bin
ln -sf python3 python

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", pathJoin(apphome, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(apphome, "lib"))
__END__
