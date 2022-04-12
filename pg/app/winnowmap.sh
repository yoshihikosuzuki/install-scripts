#!/bin/bash
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

MODROOT=/hpgwork2/yoshihiko_s/app
APP=winnowmap
VER=2.03

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

wget -O - https://github.com/marbl/Winnowmap/archive/refs/tags/v$VER.tar.gz | tar xzvf -
mv Winnowmap-$VER $VER
cd $VER && make

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
