#!/bin/bash
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

PG_DIR=$HOME/tmp

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/hpgwork2/yoshihiko_s/app/
APP=tree
VER=2.0.2

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
mv ${PG_DIR}/unix-tree-$VER.tar.gz .
tar xzvf unix-tree-$VER.tar.gz
mv unix-tree-$VER $VER
cd $VER && make

# WRITE A MODULEFILE
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
