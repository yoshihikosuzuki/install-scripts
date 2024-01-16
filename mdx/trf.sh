#!/bin/bash
module purge
set -eux

MODROOT=/large/yoshihiko_s/app
APP=trf
VER=4.09.1

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR && cd $APPDIR

wget https://github.com/Benson-Genomics-Lab/TRF/releases/download/v$VER/trf409.linux64
mv trf409.linux64 $APP
chmod +x $APP

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
