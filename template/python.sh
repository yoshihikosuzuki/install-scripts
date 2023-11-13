#!/bin/bash
module purge
set -eux

## LOAD DEPENDENCIES IF NEEDED
module use /path/to/.modulefiles
module load python/xxx

## DEFINE WHERE TO INSTALL, APP NAME, AND VERSION
MODROOT=
APP=
VER=

APPDIR=$MODROOT/$APP
MODFILE_DIR=$MODROOT/.modulefiles/$APP

## DOWNLOAD SOURCE CODE, ETC., AND PREPARE `$APPDIR/$VER`
mkdir -p $APPDIR && cd $APPDIR
wget -O - /path/to/tarball | tar xzvf -
mv $APP-$VER $VER   # rename $APP-$VER as appropriate

## INSTALL
cd $VER
mkdir -p lib/pythonX.X/site-packages
### Case 1: Via pip
PYTHONUSERBASE=$(pwd) pip install --force-reinstall --user xxx
### Case 2: Via setuptools (`pip install --user .` is better?)
PYTHONUSERBASE=$(pwd) python setup.py install --user

## MODULEFILE
mkdir -p $MODFILE_DIR && cd $MODFILE_DIR
cat <<__END__ >$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("python/xxx")
prepend_path("PATH", pathJoin(apphome, "bin"))
prepend_path("PYTHONPATH", pathJoin(apphome, "lib/pythonX.X/site-packages"))
__END__
