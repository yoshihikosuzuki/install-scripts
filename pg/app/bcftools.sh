#!/bin/bash
module purge
set -eux

source /bio/lmod/lmod/init/bash
module use /hpgwork2/yoshihiko_s/app/.modulefiles
module load python/3.7.13

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/hpgwork2/yoshihiko_s/app
APP=bcftools
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
cd $VER
mkdir -p lib/python3.7/site-packages
PYTHONUSERBASE=$(pwd) pip install matplotlib --force-reinstall --user

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("python/3.7.13")
prepend_path("PATH", pathJoin(apphome, "bin"))
prepend_path("PYTHONPATH", pathJoin(apphome, "lib/python3.7/site-packages"))
__END__
