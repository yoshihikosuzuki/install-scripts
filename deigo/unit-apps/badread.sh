#!/bin/bash
set -eu

# LOAD DEPENDENCIES IF NEEDED
module load python/3.7.3

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/hpcshare/appsunit/MyersU
APP=badread
VER=0.2.0

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
wget -O - https://github.com/rrwick/$APP/archive/refs/tags/v$VER.tar.gz | tar xzvf -
mkdir -p $VER/lib/python3.7/site-packages && cd Badread-$VER
PYTHONUSERBASE=$APPDIR/$VER pip install --force-reinstall --user .
cd .. && rm -rf Badread-$VER

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("python/3.7.3")
prepend_path("PATH", pathJoin(apphome, "bin"))
prepend_path("PYTHONPATH", pathJoin(apphome, "lib/python3.7/site-packages"))
__END__
