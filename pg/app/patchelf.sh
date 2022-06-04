#!/bin/bash
module purge
set -eux

module use /hpgwork2/yoshihiko_s/app/.modulefiles
module load gcc/9.2.0

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/hpgwork2/yoshihiko_s/app
APP=patchelf
VER=0.14.2

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
wget -O - https://github.com/NixOS/patchelf/archive/refs/tags/$VER.tar.gz | tar xzvf -
mkdir $VER
cd $APP-$VER
unset PERL5LIB
./bootstrap.sh
cd ..
mkdir build
cd build
../$APP-$VER/configure --prefix=$APPDIR/$VER
make
make install
cd ..
rm -r $APP-$VER build

# WRITE A MODULEFILE
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
