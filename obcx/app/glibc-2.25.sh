#!/bin/bash
module purge
set -eu
module use /work/00/gg57/g57015/app/.modulefiles
module load gcc/7.5.0 openssl/1.1.1
set -x

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/work/00/gg57/g57015/app
APP=glibc
VER=2.25

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
depends_on("gcc/7.5.0")
prepend_path("LD_LIBRARY_PATH", apphome)
__END__
