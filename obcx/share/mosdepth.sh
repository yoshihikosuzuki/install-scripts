#!/bin/bash
module purge
set -eux

MODROOT=/work/00/gg57/share/yoshi-tools
APP=mosdepth
VER=0.3.1

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR

wget https://github.com/brentp/mosdepth/releases/download/v$VER/mosdepth
chmod +x mosdepth

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
