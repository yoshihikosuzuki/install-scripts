#!/bin/bash
module purge
set -eux

module use /nfs/data05/yoshihiko_s/app/.modulefiles
module load R/4.0.0

MODROOT=/nfs/data05/yoshihiko_s/app
APP=genomescope
VER=2.0

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

git clone https://github.com/tbenavi1/genomescope2.0
mv genomescope2.0 $VER
cd $VER
mkdir -p lib/R
cat <<__END__ >install.R
local_lib_path = "./lib/R"
install.packages('minpack.lm', lib=local_lib_path)
install.packages('jsonlite', lib=local_lib_path)
install.packages('argparse', lib=local_lib_path)
install.packages('.', repos=NULL, type="source", lib=local_lib_path)
__END__
Rscript install.R
Rscript -e 'install.packages(c("minpack.lm", "R6", "jsonlite", "argparse", "findpython"), lib="./lib/R")'
RSCRIPT=$(which Rscript)
sed -i "s|#!/usr/bin/env Rscript|#!${RSCRIPT} --vanilla|" genomescope.R
mkdir -p bin
mv genomescope.R bin/

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("kmc/genomescope")
prepend_path("PATH", pathJoin(apphome, "bin"))
prepend_path("R_LIBS", pathJoin(apphome, "lib/R"))
__END__
