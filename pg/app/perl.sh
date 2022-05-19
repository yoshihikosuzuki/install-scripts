#!/bin/bash
module purge
set -eux

PG_DIR=$HOME/tmp

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/hpgwork2/yoshihiko_s/app
APP=perl
VER=5.34.1

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
mv $PG_DIR/perl-$VER.tar.gz .
tar xzvf perl-$VER.tar.gz
mkdir $VER
cd perl-$VER
./Configure -des -Dprefix=$APPDIR/$VER
make
make install
cd ..
rm -f perl-$VER

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
__END__
