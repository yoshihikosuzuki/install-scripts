#!/bin/bash
module purge
set -eux

MODROOT=/large/yoshihiko_s/app
APP=gbwtgraph
VER=1.0

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

wget -O - https://github.com/jltsiren/gbwtgraph/archive/refs/tags/v${VER}.tar.gz | tar xzvf -
mv $APP-$VER $VER
cd $VER
make

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("k8")
prepend_path("PATH", apphome)
prepend_path("PATH", pathJoin(apphome, "misc"))
__END__
