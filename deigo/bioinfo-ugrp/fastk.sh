#!/bin/bash
module purge
set -eux

APP=FASTK
VER=2025.06.07
MODROOT=/bucket/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

git clone https://github.com/thegenemyers/FASTK
mv FASTK $VER
cd $VER
make

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
whatis("URL: ".."https://github.com/thegenemyers/FASTK")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."k-mer counter")
whatis("Description: ".."A fast K-mer counter for high-fidelity shotgun datasets.")

-- Package settings
prepend_path("PATH", apphome)
__END__
