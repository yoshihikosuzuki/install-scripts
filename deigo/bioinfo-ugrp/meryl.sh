#!/bin.bash

APP=meryl
VER=1.3
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

wget -O - https://github.com/marbl/meryl/releases/download/v$VER/meryl-$VER.Linux-amd64.tar.xz | tar Jxvf -
mv $APP-$VER $VER

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
whatis("URL: ".."https://github.com/marbl/meryl")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."assembly")
whatis("Description: ".."A genomic k-mer counter (and sequence utility) with nice features.")

-- Package settings
prepend_path("PATH", apphome.."/bin")
__END__
