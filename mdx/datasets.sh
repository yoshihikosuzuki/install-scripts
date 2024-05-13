#!/bin/bash
module purge
set -eux

MODROOT=/large/yoshihiko_s/app
APP=datasets
VER=16.15.0

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
mkdir $VER
cd $VER
wget https://github.com/ncbi/datasets/releases/download/v${VER}/linux-amd64.cli.package.zip
unzip linux-amd64.cli.package.zip
rm linux-amd64.cli.package.zip

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
