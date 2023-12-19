#!/bin/bash
module purge
set -eux

source /large/share/app/lmod/bash
module use /large/yoshihiko_s/app/.modulefiles
module load libffi/3.4.4

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/large/yoshihiko_s/app
APP=python
VER=3.8.13

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
git clone https://github.com/python/cpython
cd cpython
git checkout 3.8
./configure --prefix $APPDIR/$VER --with-ensurepip=install --enable-optimizations
make
make install
cd ..
# rm -rf cpython
chmod -w $VER/lib/python3.8/site-packages
cd $VER/bin
ln -sf python3 python
ln -sf pip3 pip

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
