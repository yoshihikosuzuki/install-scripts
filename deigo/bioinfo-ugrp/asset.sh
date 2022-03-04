#!/bin/bash

APP=asset
VER=1.0.3
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

git clone https://github.com/dfguan/asset
mv asset $VER && cd $VER/src && make

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
whatis("URL: ".."https://github.com/dfguan/asset")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."assembly")
whatis("Description: ".."assembly evaluation tool.")

-- Package settings
depends_on("samtools", "bedtools", "bwa", "Other/minimap2")
prepend_path("PATH", apphome.."/bin")
prepend_path("PATH", apphome.."/scripts")
__END__
