#!/bin/bash
module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data05/yoshihiko_s/app
APP=htslib
VER=1.15.1

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
wget -O - https://github.com/samtools/$APP/releases/download/$VER/$APP-$VER.tar.bz2 | tar xjvf -
mkdir $VER
cd $APP-$VER
./configure --prefix=$APPDIR/$VER
make
make install
cd ..
rm -r $APP-$VER

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
prepend_path("LD_LIBRARY_PATH", pathJoin(apphome, "lib"))
prepend_path("CPATH", pathJoin(apphome, "include"))
__END__
