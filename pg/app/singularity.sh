#!/bin/bash
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

MODROOT=/hpgwork2/yoshihiko_s/app
APP=singularity
VER=3.7.4

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

wget -O - https://github.com/sylabs/singularity/releases/download/v$VER/singularity-$VER.tar.gz | tar zxvf -
mv singularity $VER
cd $VER && ./mconfig --prefix=$APPDIR/$VER

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
