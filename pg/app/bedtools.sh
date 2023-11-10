#!/bin/bash
module purge
set -eux

module use /bio/package/.modulefiles
module load gcc/9.2.0

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data05/yoshihiko_s/app
APP=bedtools
VER=2.30.0

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
wget -O - https://github.com/arq5x/bedtools2/releases/download/v$VER/$APP-$VER.tar.gz | tar xzvf -
mv bedtools2 $VER
cd $VER
export LDFLAGS="-L/bio/package/gcc/gcc9/lib64 -Wl,-rpath=/bio/package/gcc/gcc9/lib64 -L/bio/package/gcc/gcc9/lib -Wl,-rpath=/bio/package/gcc/gcc9/lib $LDFLAGS"
make

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", pathJoin(apphome, "bin"))
prepend_path("PATH", pathJoin(apphome, "scripts"))
__END__
