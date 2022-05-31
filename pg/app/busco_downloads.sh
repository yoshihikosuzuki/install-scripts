#!/bin/bash
module purge
set -eux

PG_DIR=$HOME/tmp

MODROOT=/hpgwork2/yoshihiko_s/app
APP=busco_downloads
VER=5_2022.05.31

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR && cd $APPDIR

# mv ${PG_DIR}/busco/file_versions.tsv .
# mv ${PG_DIR}/busco/busco-data.ezlab.org/v5/data/lineages/ .
# untar

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
