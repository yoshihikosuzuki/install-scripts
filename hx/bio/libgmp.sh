#!/bin/bash
# NOTE: Install on **hx03**
# NOTE: Run the following commands outside this script before running it
# $ sudo su bio -
# $ . /etc/profile
# $ source /bio/lmod/lmod/init/bash

module purge
set -eux

module use /bio/package/.modulefiles
module load gcc/9.3.0

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/bio/package
APP=libgmp
VER=5.0.0

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
wget --no-check-certificate -O - https://ftp.jaist.ac.jp/pub/GNU/gmp/gmp-$VER.tar.gz | tar zxvf -
cd gmp-$VER
./configure --prefix=$APPDIR/$VER
make
make install
cd ..
rm -r gmp-$VER

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
prepend_path("LIBRARY_PATH", pathJoin(apphome, "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(apphome, "lib"))
prepend_path("CPATH", pathJoin(apphome, "include"))
__END__
