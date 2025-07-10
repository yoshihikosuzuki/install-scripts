#!/bin/bash
module purge
set -eux

## DEFINE WHERE TO INSTALL, APP NAME, AND VERSION
MODROOT=/nfs/data05/yoshihiko_s/app
APP=java
VER=21.0.7

APPDIR=$MODROOT/$APP
MODFILE_DIR=$MODROOT/.modulefiles/$APP

## DOWNLOAD SOURCE CODE, ETC., AND PREPARE `$APPDIR/$VER`
mkdir -p $APPDIR && cd $APPDIR
wget -O - https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz | tar xzvf -
mv jdk-${VER} ${VER}

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
prepend_path("LD_LIBRARY_PATH", pathJoin(apphome, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(apphome, "lib"))
prepend_path("LDFLAGS", "-L" .. pathJoin(apphome, "lib"), " ")
prepend_path("CPATH", pathJoin(apphome, "include"))
prepend_path("CPPFLAGS", "-I" .. pathJoin(apphome, "include"), " ")
__END__
