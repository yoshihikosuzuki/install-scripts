#!/bin/bash
module purge
set -eux

module use /large/yoshihiko_s/app/.modulefiles
module load curl

MODROOT=/large/yoshihiko_s/app
APP=dazz_db
VER=2025.02.17

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

git clone https://github.com/thegenemyers/DAZZ_DB
mv DAZZ_DB $VER
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
