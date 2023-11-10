#!/bin/bash
module purge
set -eux

## LOAD DEPENDENCIES IF NEEDED
module use /path/to/.modulefiles
module load R/xxx

## DEFINE WHERE TO INSTALL, APP NAME, AND VERSION
MODROOT=
APP=
VER=

APPDIR=$MODROOT/$APP
MODFILE_ROOT=$MODROOT/.modulefiles
MODFILE_DIR=$MODFILE_ROOT/$APP

## DOWNLOAD SOURCE CODE, ETC., AND PREPARE `$APPDIR/$VER`
mkdir -p $APPDIR && cd $APPDIR
wget -O - /path/to/xxx.tar.gz | tar xzvf -
mv $APP-$VER $VER   # rename $APP-$VER as appropriate

## INSTALL
cd $VER
mkdir -p lib/R
Rscript -e 'install.packages(c("xxx", "yyy"), lib="./lib/R")'
for FILE in *.R; do
    sed -i 's|#!/usr/bin/env Rscript|#!/usr/bin/env -S Rscript --vanilla|' ${FILE}
done

## MODULEFILE
mkdir -p $MODFILE_DIR && cd $MODFILE_DIR
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("R/xxx")
prepend_path("PATH", apphome)
prepend_path("R_LIBS", pathJoin(apphome, "lib/R"))
__END__
