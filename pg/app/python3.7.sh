#!/bin/bash
module purge
set -eux

module use /bio/package/.modulefiles
module use /hpgwork2/yoshihiko_s/app/.modulefiles
module load gcc/9.2.0 openssl/1.1.1d

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/hpgwork2/yoshihiko_s/app
APP=python
VER=3.7.13

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
git clone https://github.com/python/cpython
cd cpython
git checkout 3.7
./configure --prefix $APPDIR/$VER --with-ensurepip=install --with-openssl=$OPENSSL_PATH --enable-optimizations
make
make install
cd ..
rm -rf cpython

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("gcc/9.2.0")
prepend_path("PATH", pathJoin(apphome, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(apphome, "lib"))
__END__
