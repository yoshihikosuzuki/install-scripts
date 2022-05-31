#!/bin/bash
module purge
set -eux

MODROOT=/hpgwork2/yoshihiko_s/app
APP=busco_downloads
VER=5_2022.05.31

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR && cd $APPDIR

cd lineages
for FILE in *.tar.gz; do
    tar xzvf $FILE
done

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ > $APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
setenv("BUSCO_DOWNLOADS", apphome)
__END__
