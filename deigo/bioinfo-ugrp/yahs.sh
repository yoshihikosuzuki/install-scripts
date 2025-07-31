#!/bin/bash

APP=yahs
VER=1.2.2
MODROOT=/bucket/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

wget -O - https://github.com/c-zhou/yahs/archive/refs/tags/v${VER}.tar.gz | tar xzvf -
mv $APP-$VER $VER
cd $VER && make

cd $MODROOT/modulefiles/
mkdir -p $APP
cat <<'__END__' > $APP/$VER.lua
-- Default settings
local modroot    = "/bucket/BioinfoUgrp"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package information
whatis("Name: "..appname)
whatis("Version: "..appversion)
whatis("URL: ".."https://github.com/c-zhou/yahs")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."scaffolding, Hi-C")
whatis("Description: ".."Yet another Hi-C scaffolding tool.")

-- Package settings
prepend_path("PATH", apphome)
__END__
