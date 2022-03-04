#!/bin/bash

APP=DAZZ_DB
VER=2021.03.30
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

git clone https://github.com/thegenemyers/DAZZ_DB
mv DAZZ_DB $VER && cd $VER && make

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
whatis("URL: ".."https://github.com/thegenemyers/DAZZ_DB")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."assembly, sequencing")
whatis("Description: ".."The Dazzler Data Base.")

-- Package settings
prepend_path("PATH", apphome)
__END__
