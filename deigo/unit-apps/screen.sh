#!/bin/bash
set -eu

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/hpcshare/appsunit/MyersU
APP=screen
VER=4.8.0

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
wget -O - https://ftp.gnu.org/gnu/screen/$APP-$VER.tar.gz | tar xzvf -
mkdir $VER && cd $APP-$VER
./configure --prefix=$APPDIR/$VER && make && make install
cd .. && rm -rf $APP-$VER

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
__END__
