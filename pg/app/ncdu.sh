#!/bin/bash
module purge
set -eux

MODROOT=/nfs/data05/yoshihiko_s/app
APP=ncdu
VER=1.15.1

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

git clone https://github.com/rofl0r/ncdu
mkdir $VER
cd ncdu
autoreconf -i
./configure --prefix=$APPDIR/$VER
make
make install
cd ..
rm -r ncdu

cd $VER/bin
ln -sf ncdu du

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
