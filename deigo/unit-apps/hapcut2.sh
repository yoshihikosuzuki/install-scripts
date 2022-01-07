#!/bin/bash
set -eu

module load htslib/1.14

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/hpcshare/appsunit/MyersU
APP=hapcut2
VER=1.3.1

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
wget -O - https://github.com/vibansal/$APP/archive/refs/tags/v1.3.3.tar.gz | tar xzvf -
mkdir $VER && cd HapCUT2-1.3.3 && make
chmod +x utilities/*.py && mv build/HAPCUT2 build/extractHAIRS utilities/*.py $APPDIR/$VER
cd .. && rm -r HapCUT2-1.3.3

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("htslib/1.14")
prepend_path("PATH", apphome)
__END__
