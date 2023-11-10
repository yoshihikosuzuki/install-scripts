#!/bin/bash
module purge
set -eux

module use /bio/package/.modulefiles
module load gcc/9.2.0

MODROOT=/nfs/data05/yoshihiko_s/app
APP=kmc
VER=genomescope

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

git clone https://github.com/tbenavi1/KMC
mv KMC $VER
cd $VER
make

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", pathJoin(apphome, "bin"))
__END__
