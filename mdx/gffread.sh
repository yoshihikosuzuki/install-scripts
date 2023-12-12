#!/bin/bash
module purge
set -eux

MODROOT=/large/yoshihiko_s/app
APP=gffread
VER=0.12.7

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

wget -O - https://github.com/gpertea/gffread/releases/download/v$VER/gffread-$VER.Linux_x86_64.tar.gz | tar zxvf -
mv gffread-$VER.Linux_x86_64 $VER

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
