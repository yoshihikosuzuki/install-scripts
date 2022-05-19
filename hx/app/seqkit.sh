#!/bin/bash
module purge
set -eux

MODROOT=/work/yoshihiko_s/app
APP=seqkit
VER=2.0.0

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR

wget -O - https://github.com/shenwei356/seqkit/releases/download/v$VER/seqkit_linux_amd64.tar.gz | tar xzvf -

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
