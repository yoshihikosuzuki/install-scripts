#!/bin/bash
module purge
set -eux

MODROOT=/large/yoshihiko_s/app
APP=asset
VER=1.0.3

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

git clone https://github.com/dfguan/asset
mv asset $VER
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
depends_on("samtools", "bedtools", "bwa", "minimap2")
prepend_path("PATH", pathJoin(apphome, "bin"))
prepend_path("PATH", pathJoin(apphome, "scripts"))
__END__
