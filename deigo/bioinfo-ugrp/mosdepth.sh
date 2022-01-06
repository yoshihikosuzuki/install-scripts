#!/bin.bash

APP=mosdepth
VER=0.3.1
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR

wget https://github.com/brentp/mosdepth/releases/download/v$VER/mosdepth && chmod +x mosdepth

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
whatis("URL: ".."https://github.com/brentp/mosdepth")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."assembly")
whatis("Description: ".."fast BAM/CRAM depth calculation for WGS, exome, or targeted sequencing.")

-- Package settings
prepend_path("PATH", apphome)
__END__
