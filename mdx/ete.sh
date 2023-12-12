#!/bin/bash
module purge
set -eux

MODROOT=/large/yoshihiko_s/app
APP=ete
VER=3.1.3

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh -b -p $APPDIR/$VER
cd $VER
./bin/pip install https://github.com/etetoolkit/ete/archive/ete4.zip
rm -rf pkgs

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
