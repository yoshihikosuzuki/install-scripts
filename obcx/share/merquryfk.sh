#!/bin/bash
module purge
set -eux

module use /work/00/gg57/share/yoshi-tools/.modulefiles
module load R/4.0.0

MODROOT=/work/00/gg57/share/yoshi-tools
APP=merquryfk
VER=2022.04.15

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

git clone https://github.com/thegenemyers/MERQURY.FK
mv MERQURY.FK $VER
cd $VER
RSCRIPT=$(which Rscript)
for FILE in KatComp.c KatGC.c MerquryFK.c PloidyPlot.c asm_plotter.c cn_plotter.c hap_plotter.c; do
    sed -i "s|Rscript|Rscript --vanilla|" $FILE
done
for FILE in *.h; do
    sed -i "s|#!/usr/bin/env Rscript|#!${RSCRIPT} --vanilla|" $FILE
done
make
mkdir -p bin
mv ASMplot CNplot HAPmaker HAPplot KatComp KatGC MerquryFK PloidyPlot bin/
mkdir -p lib/R
Rscript -e 'install.packages(c("argparse","R6","jsonlite","findpython","ggplot2","scales","cowplot","viridis"), repos="https://cran.ism.ac.jp/", lib="./lib/R")'

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
