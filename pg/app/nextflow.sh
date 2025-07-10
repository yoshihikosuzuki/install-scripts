#!/bin/bash
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data05/yoshihiko_s/app
APP=nextflow
VER=25.04.6

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
mkdir -p $VER && cd $VER
curl -s https://get.nextflow.io | bash

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("java/21")
prepend_path("PATH", apphome)
__END__
