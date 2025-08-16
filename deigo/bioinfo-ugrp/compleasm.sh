#!/bin/bash

APP=compleasm
VER=0.2.7
MODROOT=/bucket/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh -b -p $APPDIR/$VER
cd $VER
./bin/mamba install -y python=3.7
./bin/mamba install -c bioconda -y $APP=$VER sepp pandas
rm -rf pkgs

cd $MODROOT/modulefiles/
mkdir -p $APP
cat <<'__END__' > $APP/$VER.lua
-- Default settings
local modroot    = "/bucket/BioinfoUgrp"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", pathJoin(apphome, "bin"))
__END__
