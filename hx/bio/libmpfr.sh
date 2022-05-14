#!/bin/bash
# NOTE: Run the commands below on **hx03** (NOT on a CentOS 7 node) in an interactive shell

# NOTE: Run the following commands outside this script before running it
# $ sudo su bio -
# $ . /etc/profile

set -eux

module load gcc/9.3.0

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/bio/package
APP=libmpfr
VER=2.4.0

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
mkdir $VER
wget --no-check-certificate -O - https://ftp.jaist.ac.jp/pub/GNU/mpfr/mpfr-$VER.tar.gz | tar zxvf -
cd mpfr-$VER
./configure --prefix=$APPDIR/$VER
make
make install

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", apphome)
prepend_path("LIBRARY_PATH", pathJoin(apphome, "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(apphome, "lib"))
prepend_path("CPATH", pathJoin(apphome, "include"))
__END__
