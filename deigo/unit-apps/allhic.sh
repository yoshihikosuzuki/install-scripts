#!/bin/bash
set -eu

module load python/3.7.3

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/hpcshare/appsunit/MyersU
APP=allhic
VER=0.9.13

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
wget -O - https://github.com/tanghaibao/$APP/releases/download/v$VER/${APP}_${VER}_Linux_64-bit.tar.gz | tar xzvf -

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
