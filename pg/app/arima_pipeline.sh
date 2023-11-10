#!/bin/bash
module purge
set -eux

MODROOT=/nfs/data05/yoshihiko_s/app
APP=arima_pipeline
VER=2019.02.08

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

git clone https://github.com/ArimaGenomics/mapping_pipeline
mv mapping_pipeline $VER
cd $VER
chmod +x *.pl

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("samtools", "picard", "bwa")
prepend_path("PATH", apphome)
__END__
