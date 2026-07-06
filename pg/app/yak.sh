#!/bin/bash
module purge
set -eux

MODROOT=/nfs/data05/yoshihiko_s/app
APP=yak
VER=0.1

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

wget -O - https://github.com/lh3/$APP/archive/refs/tags/v$VER.tar.gz | tar xzvf -
mv $APP-$VER $VER && cd $VER
make

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
