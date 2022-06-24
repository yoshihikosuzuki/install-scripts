#!/bin/bash
module purge
set -eux

module use /hpgwork2/yoshihiko_s/app/.modulefiles
module load R/4.0.0

MODROOT=/hpgwork2/yoshihiko_s/app
APP=merqury
VER=1.3

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

wget -O - https://github.com/marbl/merqury/archive/refs/tags/v$VER.tar.gz | tar zxvf -
mv $APP-$VER $VER
cd $VER
sed -i 's/echo $?/echo 1/' util/util.sh
RSCRIPT=$(which Rscript)
for FILE in plot/*.R; do
    sed -i "s|#!/usr/bin/env Rscript|#!${RSCRIPT} --vanilla|" ${FILE}
done
mkdir -p lib/R
Rscript -e 'install.packages(c("argparse","R6","jsonlite","findpython","ggplot2","scales"), lib="./lib/R")'

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("meryl/1.3")
prepend_path("PATH", apphome)
prepend_path("R_LIBS", pathJoin(apphome, "lib/R"))
setenv("MERQURY", apphome)
__END__
