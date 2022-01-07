#!/bin/bash
set -eu

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/hpcshare/appsunit/MyersU
APP=biobambam2
VER=2.0.87

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
wget -O - https://github.com/gt1/biobambam2/releases/download/2.0.87-release-20180301132713/biobambam2-2.0.87-release-20180301132713-x86_64-etch-linux-gnu.tar.gz | tar xzvf -
mv biobambam2/2.0.87-release-20180301132713/x86_64-etch-linux-gnu/ $VER && rm -r biobambam2

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
prepend_path("LIBRARY_PATH", pathJoin(apphome, "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(apphome, "lib"))
__END__
