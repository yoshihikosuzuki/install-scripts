#!/bin/bash
module purge
set -eux

MODROOT=/work/00/gg57/share/yoshi-tools
APP=arima_pipeline
VER=2019.03.02

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
depends_on("samtools/1.15.1", "picard/2.27.1", "bwa/0.7.17")
prepend_path("PATH", apphome)
__END__
