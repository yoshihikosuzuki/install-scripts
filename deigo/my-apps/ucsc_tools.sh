#!/bin/bash
module purge
set -eux

MODROOT=/hpcshare/appsunit/MyersU/yoshihiko-suzuki
APP=ucsc_tools
VER=2024.09.13

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# copied from pg

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", pathJoin(apphome, "bin"))
__END__
