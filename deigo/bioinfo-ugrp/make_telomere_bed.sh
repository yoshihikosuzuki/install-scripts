#!/bin/bash

module load python/3.7.3

APP=make_telomere_bed
VER=2021.05.20
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

git clone https://github.com/yoshihikosuzuki/make_telomere_bed
mv make_telomere_bed $VER && cd $VER
mkdir -p lib/python3.7/site-packages
PYTHONUSERBASE=$(pwd) python setup.py install --user

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
whatis("URL: ".."https://github.com/yoshihikosuzuki/make_telomere_bed")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."telomere")
whatis("Description: ".."Make a .bed file for telomeres in a contig/scaffold file.")

-- Package settings
depends_on("python/3.7.3", "Other/trf")
prepend_path("PATH", apphome.."/bin")
prepend_path("PYTHONPATH", apphome.."/lib/python3.7/site-packages")
__END__
