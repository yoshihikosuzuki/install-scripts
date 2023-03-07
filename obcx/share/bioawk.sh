#!/bin/bash
module purge
set -eux

MODROOT=/work/00/gg57/share/yoshi-tools
APP=bioawk
VER=1.0

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

wget -O - https://github.com/lh3/bioawk/archive/refs/tags/v$VER.tar.gz | tar xzvf -
mv $APP-$VER $VER
cd $VER
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
