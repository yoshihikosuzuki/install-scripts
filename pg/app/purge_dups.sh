#!/bin/bash
module purge
set -eux

MODROOT=/nfs/data05/yoshihiko_s/app
APP=purge_dups
VER=1.2.5

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

git clone https://github.com/dfguan/purge_dups
mv purge_dups $VER
cd $VER/src
make

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("minimap2")
prepend_path("PATH", pathJoin(apphome, "bin"))
prepend_path("PATH", pathJoin(apphome, "scripts"))
__END__
