#!/bin/bash

APP=mummer
VER=4.0.0rc1
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR/$VER
cd $APPDIR

wget -O - https://github.com/mummer4/mummer/releases/download/v$VER/$APP-$VER.tar.gz | tar zxvf -
cd $APP-$VER && ./configure --prefix=$APPDIR/$VER && make && make install && cd .. && rm -r $APP-$VER

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
whatis("URL: ".."https://mummer4.github.io/")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."alignment")
whatis("Description: ".."MUMmer is a system for rapidly aligning large DNA sequences to one another.")

-- Package settings
prepend_path("PATH", apphome.."/bin")
__END__
