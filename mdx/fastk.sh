#!/bin/bash
module purge
set -eux

module use /large/yoshihiko_s/app/.modulefiles
module load curl

MODROOT=/large/yoshihiko_s/app
APP=fastk
VER=2022.04.26

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

git clone https://github.com/thegenemyers/FASTK
mv FASTK $VER
cd $VER
# git checkout ba0d260
make clean
cat <<__END__ >HTSLIB/htslib_static.mk
HTSLIB_static_LDFLAGS = -L/large/yoshihiko_s/app/curl/8.5.0/lib -Wl,-rpath=/large/yoshihiko_s/app/curl/8.5.0/lib
HTSLIB_static_LIBS = -lz -lm -lbz2 -llzma -lcurl
__END__
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
