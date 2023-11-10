#!/bin/bash
module purge
set -eux

MODROOT=/nfs/data05/yoshihiko_s/app
APP=meryl
VER=1.3

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

wget -O - https://github.com/marbl/meryl/releases/download/v$VER/meryl-$VER.Linux-amd64.tar.xz | tar Jxvf -
mv $APP-$VER $VER

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("gcc/9.2.0")
prepend_path("PATH", pathJoin(apphome, "bin"))
__END__
