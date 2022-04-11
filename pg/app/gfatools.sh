#!/bin/bash
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

PG_DIR=$HOME/tmp

MODROOT=/hpgwork2/yoshihiko_s/app/
APP=gfatools
VER=0.5

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

mv ${PG_DIR}/v$VER.tar.gz .
tar xzvf v$VER.tar.gz
mv $APP-$VER $VER
cd $VER && make

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", apphome)
__END__
