#!/bin/bash
# Installed on CentOS 7
module purge
set -eux

module use /hpgwork2/yoshihiko_s/app/.modulefiles
module load R/4.2.0 gcc/9.2.0

APP=genescope
VER=2021.03.26
MODROOT=/hpgwork2/yoshihiko_s/app

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

git clone https://github.com/thegenemyers/GENESCOPE.FK
mv GENESCOPE.FK $VER
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
Rscript -e 'install.packages(c("R6", "jsonlite", "findpython"), lib="./lib/R")'
RSCRIPT=$(which Rscript)
sed -i "s|#!/usr/bin/env Rscript|#!${RSCRIPT} --vanilla|" GeneScopeFK.R
mkdir -p bin
mv GeneScopeFK.R bin/

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("fastk/2022.04.26")
prepend_path("PATH", pathJoin(apphome, "bin"))
prepend_path("R_LIBS", pathJoin(apphome, "lib/R"))
__END__
