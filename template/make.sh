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
MODFILE_ROOT=$MODROOT/.modulefiles
MODFILE_DIR=$MODFILE_ROOT/$APP

## DOWNLOAD SOURCE CODE, ETC., AND PREPARE `$APPDIR/$VER`
mkdir -p $APPDIR && cd $APPDIR
wget -O - /path/to/tarball | tar xzvf -

## INSTALL
mkdir $VER
cd $APP-$VER   # rename $APP-$VER as appropriate
./configure --prefix=$APPDIR/$VER   # if using autotools
make
make install
cd ..
rm -r $APP-$VER

## MODULEFILE
mkdir -p $MODFILE_DIR && cd $MODFILE_DIR
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("xxx")
prepend_path("PATH", pathJoin(apphome, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(apphome, "lib"))
prepend_path("LDFLAGS", "-L" .. pathJoin(apphome, "lib"), " ")
prepend_path("CPATH", pathJoin(apphome, "include"))
prepend_path("CPPFLAGS", "-I" .. pathJoin(apphome, "include"), " ")
__END__
