#!/bin/bash
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

PG_DIR=$HOME/tmp

MODROOT=/hpgwork2/yoshihiko_s/app/
APP=canu
VER=2.1.1

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

mv ${PG_DIR}/$APP-$VER.Linux-amd64.tar.xz .
tar Jxvf $APP-$VER.Linux-amd64.tar.xz
mv $APP-$VER $VER

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", apphome.."/bin")
__END__
