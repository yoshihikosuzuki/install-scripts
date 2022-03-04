#!/bin/bash

APP=k8
VER=0.2.5
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

wget -O - https://github.com/attractivechaos/k8/releases/download/$VER/$APP-$VER.tar.bz2 | tar xjvf -
mv $APP-$VER $VER && cd $VER
ln -sf k8-Linux k8

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
whatis("URL: ".."https://github.com/attractivechaos/k8")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."javascript")
whatis("Description: ".."k8 Javascript shell.")

-- Package settings
prepend_path("PATH", apphome)
__END__
