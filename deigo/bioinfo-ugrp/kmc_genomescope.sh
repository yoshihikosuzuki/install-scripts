#!/bin/bash

APP=KMC
VER=genomescope
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

git clone https://github.com/tbenavi1/KMC
mv KMC $VER && cd $VER && make

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
whatis("URL: ".."https://github.com/tbenavi1/KMC")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."k-mer counter")
whatis("Description: ".."Fast and frugal disk based k-mer counter (version for GenomeScope and Smudgeplot).")

-- Package settings
prepend_path("PATH", apphome.."/bin")
__END__
