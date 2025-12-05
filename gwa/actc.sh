#!/bin/bash
module purge
set -eux

MODROOT=/lustre12/home/yoshihiko_s-pg/app
APP=actc
VER=0.6.1

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

mkdir -p $VER
cd $VER
wget https://github.com/PacificBiosciences/actc/releases/download/v${VER}/actc
chmod +x actc

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
