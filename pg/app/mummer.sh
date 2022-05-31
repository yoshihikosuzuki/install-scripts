#!/bin/bash
module purge
set -eux

module use /bio/package/.modulefiles
module load gcc/9.2.0

MODROOT=/hpgwork2/yoshihiko_s/app
APP=mummer
VER=4.0.0rc1

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR/$VER && cd $APPDIR

wget -O - https://github.com/mummer4/mummer/releases/download/v$VER/$APP-$VER.tar.gz | tar zxvf -
cd $APP-$VER
./configure --prefix=$APPDIR/$VER
make
make install
cd ..
rm -r $APP-$VER

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
