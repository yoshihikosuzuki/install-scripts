#!/bin/bash
module purge
set -eux

## DEFINE WHERE TO INSTALL, APP NAME, AND VERSION
MODROOT=/nfs/data05/yoshihiko_s/app
APP=rasusa
VER=4.0.0

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

## DOWNLOAD SOURCE CODE, ETC., AND PREPARE `$APPDIR/$VER`
wget -O - https://github.com/mbhall88/rasusa/releases/download/${VER}/rasusa-${VER}-x86_64-unknown-linux-musl.tar.gz | tar xzvf -
mv rasusa-${VER}-x86_64-unknown-linux-musl $VER

## MODULEFILE
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
