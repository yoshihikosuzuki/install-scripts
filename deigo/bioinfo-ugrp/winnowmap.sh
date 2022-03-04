#!/bin/bash

APP=winnowmap
VER=2.03
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

wget -O - https://github.com/marbl/Winnowmap/archive/refs/tags/v$VER.tar.gz | tar xzvf -
mv Winnowmap-$VER $VER
cd $VER && make

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
whatis("URL: ".."https://github.com/marbl/Winnowmap")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."alignment")
whatis("Description: ".."Long read / genome alignment software")

-- Package settings
prepend_path("PATH", apphome.."/bin")
__END__
