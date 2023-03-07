#!/bin/bash
module purge
set -eux

module use /work/00/gg57/share/yoshi-tools/.modulefiles
module load R/4.0.0

MODROOT=/work/00/gg57/share/yoshi-tools
APP=genescope
VER=2021.03.26

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

git clone https://github.com/thegenemyers/GENESCOPE.FK
mv GENESCOPE.FK $VER
cd $VER
mkdir -p lib/R
cat <<__END__ >install.R
local_lib_path = "./lib/R"
install.packages('minpack.lm', repos="https://cran.ism.ac.jp/", lib=local_lib_path)
install.packages('jsonlite', repos="https://cran.ism.ac.jp/", lib=local_lib_path)
install.packages('argparse', repos="https://cran.ism.ac.jp/", lib=local_lib_path)
install.packages('.', repos=NULL, type="source", lib=local_lib_path)
__END__
Rscript install.R
Rscript -e 'install.packages(c("minpack.lm", "R6", "jsonlite", "argparse", "findpython"), repos="https://cran.ism.ac.jp/", lib="./lib/R")'
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
depends_on("fastk/2022.12.16")
prepend_path("PATH", pathJoin(apphome, "bin"))
prepend_path("R_LIBS", pathJoin(apphome, "lib/R"))
__END__
