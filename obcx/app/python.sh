#!/bin/bash
module purge
set -eu
module use /work/00/gg57/g57015/app/.modulefiles
module load openssl/1.1.1
set -x

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/work/00/gg57/g57015/app
APP=python
VER=3.11.0

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
git clone https://github.com/python/cpython
cd cpython
git checkout 3.11
./configure --prefix $APPDIR/$VER --with-ensurepip=install --with-openssl=$OPENSSL_PATH --enable-optimizations
make
make install
cd ..
rm -rf cpython
# chmod -w $VER/lib/python3.11/site-packages

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("openssl/1.1.1")
setenv("PYTHONUSERBASE", apphome)
prepend_path("PATH", pathJoin(apphome, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(apphome, "lib"))
__END__
