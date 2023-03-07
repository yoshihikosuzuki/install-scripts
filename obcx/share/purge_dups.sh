#!/bin/bash
module purge
set -eux

MODROOT=/work/00/gg57/share/yoshi-tools
APP=purge_dups
VER=1.2.6

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

wget -O - https://github.com/dfguan/purge_dups/archive/refs/tags/v${VER}.tar.gz | tar xzvf -
mv purge_dups-$VER $VER
cd $VER/src
make

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("minimap2")
prepend_path("PATH", pathJoin(apphome, "bin"))
prepend_path("PATH", pathJoin(apphome, "scripts"))
__END__
