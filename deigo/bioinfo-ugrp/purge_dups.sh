#!/bin/bash

APP=purge_dups
VER=1.2.5
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

git clone https://github.com/dfguan/purge_dups
mv purge_dups $VER && cd $VER/src && make

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
whatis("URL: ".."https://github.com/dfguan/purge_dups")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."assembly")
whatis("Description: ".."haplotypic duplication identification tool.")

-- Package settings
depends_on("Other/minimap2")
prepend_path("PATH", apphome.."/bin")
prepend_path("PATH", apphome.."/scripts")
__END__
