#!/bin/bash
module purge
set -eux

module use /work/yoshihiko_s/app/.modulefiles
module load python/3.7.13

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/work/yoshihiko_s/app
APP=fatt
VER=2021.09.05

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
git clone https://github.com/mkasa/klab
cd klab
git checkout a66c78f
./waf configure
./waf build
cd ..
mkdir $VER
mv klab/build/fatt $VER
rm -rf klab

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("gcc/9.3.0")
prepend_path("PATH", apphome)
__END__
