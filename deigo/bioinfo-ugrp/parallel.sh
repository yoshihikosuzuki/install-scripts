#!/bin.bash

APP=parallel
VER=20210622
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR/$VER
cd $APPDIR

wget -O - https://ftp.gnu.org/gnu/parallel/parallel-$VER.tar.bz2 | tar xjvf -
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
whatis("URL: ".."https://www.gnu.org/software/parallel")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."GNU, parallel")
whatis("Description: ".."A shell tool for executing jobs in parallel using one or more computers.")

-- Package settings
prepend_path("PATH", apphome.."/bin")
__END__
