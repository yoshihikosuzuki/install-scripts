#!/bin/bash
module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/large/yoshihiko_s/app
APP=odgi
VER=0.8.6

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
wget -O - https://github.com/pangenome/odgi/releases/download/v${VER}/${APP}-v${VER}.tar.gz | tar xzvf -
mkdir $VER
cd $APP-v$VER
cmake -DBUILD_STATIC=1 -H. -Bbuild
cmake --build build -- -j 3
mv bin/odgi $APPDIR/$VER/
cd ..
rm -rf $APP-v$VER

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", apphome)
__END__
