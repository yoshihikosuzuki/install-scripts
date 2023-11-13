#!/bin/bash
module purge
set -eux

## DEFINE WHERE TO INSTALL, APP NAME, AND VERSION
MODROOT=
APP=
VER=

APPDIR=$MODROOT/$APP
MODFILE_DIR=$MODROOT/.modulefiles/$APP

## DOWNLOAD SOURCE CODE, ETC., AND PREPARE `$APPDIR/$VER`
mkdir -p $APPDIR && cd $APPDIR
SCRIPT=Miniforge3-$(uname)-$(uname -m).sh
wget https://github.com/conda-forge/miniforge/releases/latest/download/${SCRIPT}
bash ${SCRIPT} -b -p $APPDIR/$VER
rm ${SCRIPT}

## INSTALL
cd $VER
./bin/mamba install -y python=3.8   # Optional, in case lower version is needed
./bin/mamba install -c defaults -c conda-forge -c bioconda -y $APP=$VER
rm -rf pkgs

## MODULEFILE
mkdir -p $MODFILE_DIR && cd $MODFILE_DIR
cat <<__END__ >$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", pathJoin(apphome, "bin"))
__END__
