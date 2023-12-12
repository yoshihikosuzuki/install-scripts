#!/bin/bash
module purge
set -eux

MODROOT=/large/yoshihiko_s/app
APP=pigz
VER=2.8

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
wget https://zlib.net/pigz/$APP-$VER.tar.gz
tar xzvf $APP-$VER.tar.gz
mv $APP-$VER $VER
cd $VER
make

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
