#!/bin.bash

APP=arima_pipeline
VER=2019.02.08
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

git clone https://github.com/ArimaGenomics/mapping_pipeline
mv mapping_pipeline $VER && cd $VER
chmod +x *.pl

cd $MODROOT/modulefiles/
mkdir -p $APP
cat <<'__END__' > $APP/$VER.lua
-- Default settings
local modroot    = "/apps/unit/BioinfoUgrp"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package information
whatis("Name: "..appname)
whatis("Version: "..appversion)
whatis("URL: ".."https://github.com/ArimaGenomics/mapping_pipeline")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."Hi-C, mapping")
whatis("Description: ".."Mapping pipeline for data generated using Arima-HiC.")

-- Package settings
depends_on("samtools", "picard", "bwa")
prepend_path("PATH", apphome)
__END__
