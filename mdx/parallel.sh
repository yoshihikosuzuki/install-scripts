#!/bin/bash
module purge
set -eux

MODROOT=/large/yoshihiko_s/app
APP=parallel
VER=20210622

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR/$VER && cd $APPDIR

wget -O - https://ftp.gnu.org/gnu/parallel/$APP-$VER.tar.bz2 | tar xjvf -
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
