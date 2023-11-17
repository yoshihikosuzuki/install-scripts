#!/bin/bash
module purge
set -eux

## DEFINE WHERE TO INSTALL, APP NAME, AND VERSION
MODROOT=/nfs/data05/yoshihiko_s/app
APP=biobambam2
VER=2.0.87

APPDIR=$MODROOT/$APP
MODFILE_DIR=$MODROOT/.modulefiles/$APP

## DOWNLOAD SOURCE CODE, ETC., AND PREPARE `$APPDIR/$VER`
mkdir -p $APPDIR && cd $APPDIR
wget -O - https://github.com/gt1/biobambam2/releases/download/2.0.87-release-20180301132713/biobambam2-2.0.87-release-20180301132713-x86_64-etch-linux-gnu.tar.gz | tar xzvf -
mv biobambam2/2.0.87-release-20180301132713/x86_64-etch-linux-gnu/ $VER && rm -r biobambam2

## INSTALL
# cd $VER
# ...

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
prepend_path("LIBRARY_PATH", pathJoin(apphome, "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(apphome, "lib"))
__END__
