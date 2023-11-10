#!/bin/bash
module purge
set -eux

module use /bio/package/.modulefiles
module load gcc/9.2.0

MODROOT=/nfs/data05/yoshihiko_s/app
APP=pstools
VER=0.1

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

wget -O - https://github.com/shilpagarg/pstools/archive/refs/tags/v$VER.tar.gz | tar xzvf -
mv $APP-$VER $VER
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
depends_on("gcc/9.2.0")
prepend_path("PATH", apphome)
__END__
