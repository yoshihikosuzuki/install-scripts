#!/bin/bash
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

MODROOT=/hpgwork2/yoshihiko_s/app
APP=canu
VER=2.1.1

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

wget -O - https://github.com/marbl/canu/releases/download/v$VER/$APP-$VER.Linux-amd64.tar.xz | tar Jxvf -
mv $APP-$VER $VER

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("java/11.0.14")
prepend_path("PATH", pathJoin(apphome, "bin"))
__END__
