#!/bin/bash

APP=trf
VER=4.09.1
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR

wget https://github.com/Benson-Genomics-Lab/TRF/releases/download/v$VER/trf409.linux64 && mv trf409.linux64 $APP && chmod +x $APP

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
whatis("URL: ".."https://github.com/Benson-Genomics-Lab/TRF")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."DNA, repeat")
whatis("Description: ".."Tandem Repeats Finder: a program to analyze DNA sequences.")

-- Package settings
prepend_path("PATH", apphome.."")
__END__
