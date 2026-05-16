#!/bin/bash
module purge
set -eux

# module use /large/yoshihiko_s/app/.modulefiles
# module load curl

MODROOT=/large/yoshihiko_s/app
APP=daligner
VER=2024.01.19

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

git clone https://github.com/thegenemyers/DALIGNER
mv DALIGNER $VER
cd $VER
make

cd $MODROOT/.modulefiles
mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", apphome)
__END__
