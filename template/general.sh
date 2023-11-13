#!/bin/bash
module purge
set -eux

## LOAD DEPENDENCIES IF NEEDED
module use /path/to/.modulefiles
module load xxx

## DEFINE WHERE TO INSTALL, APP NAME, AND VERSION
MODROOT=
APP=
VER=

APPDIR=$MODROOT/$APP
MODFILE_DIR=$MODROOT/.modulefiles/$APP

## DOWNLOAD SOURCE CODE, ETC., AND PREPARE `$APPDIR/$VER`
mkdir -p $APPDIR && cd $APPDIR
...

## INSTALL
cd $VER
...

## MODULEFILE
mkdir -p $MODFILE_DIR && cd $MODFILE_DIR
cat <<__END__ >$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("XXX")
prepend_path("PATH", apphome)
...
__END__
