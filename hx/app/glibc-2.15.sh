#!/bin/bash
module purge
set -eux

module use /bio/package/.modulefiles
module load gcc/4.9.3

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/work/yoshihiko_s/app
APP=glibc
VER=2.15

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
wget --no-check-certificate -O - https://ftp.gnu.org/gnu/glibc/glibc-$VER.tar.gz | tar xzvf -
mkdir $VER
cd $VER
LD_LIBRARY_PATH=$(echo $LD_LIBRARY_PATH | sed 's/:*$//')
../glibc-$VER/configure --prefix=$APPDIR/$VER
make
cd ..
rm -r glibc-$VER

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("LD_LIBRARY_PATH", apphome)
__END__
