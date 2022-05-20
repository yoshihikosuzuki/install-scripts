#!/bin/bash
module purge
set -eux

module use /bio/package/.modulefiles
module load gcc/9.2.0

APP=dazz_db
VER=2022.04.26
MODROOT=/hpgwork2/yoshihiko_s/app

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
