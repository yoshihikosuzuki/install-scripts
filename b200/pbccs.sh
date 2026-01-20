#!/bin/bash
module purge
set -eux

MODROOT=/lustre12/home/yoshihiko_s-pg/app
APP=pbccs
VER=6.4.0

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

mkdir -p $VER
cd $VER
wget -O - https://github.com/PacificBiosciences/ccs/releases/download/v${VER}/ccs.tar.gz | tar xzvf -
chmod +x ccs

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
