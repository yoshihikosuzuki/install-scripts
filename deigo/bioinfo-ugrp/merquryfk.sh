#!/bin/bash
module purge
set -eu

module load R/4.3.1

APP=MerquryFK
VER=2025.06.07
MODROOT=/bucket/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

git clone https://github.com/thegenemyers/MERQURY.FK
mv MERQURY.FK $VER
cd $VER

RSCRIPT=$(which Rscript)
for FILE in KatComp.c KatGC.c MerquryFK.c asm_plotter.c cn_plotter.c hap_plotter.c; do
    sed -i "s|Rscript|Rscript --vanilla|" $FILE
done
for FILE in *.h; do
    sed -i "s|#!/usr/bin/env Rscript|#!${RSCRIPT} --vanilla|" $FILE
done

make
mkdir -p bin
mv ASMplot CNplot HAPmaker HAPplot KatComp KatGC MerquryFK bin/

mkdir -p lib/R
Rscript -e 'install.packages(c("argparse","R6","jsonlite","findpython","ggplot2","scales","cowplot","viridis"), lib="./lib/R", repos=c(CRAN="https://cloud.r-project.org"))'

cd $MODROOT/modulefiles/
mkdir -p $APP
cat <<'__END__' > $APP/$VER.lua
-- Default settings
local modroot    = "/bucket/BioinfoUgrp"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package information
whatis("Name: "..appname)
whatis("Version: "..appversion)
whatis("URL: ".."https://github.com/thegenemyers/MERQURY.FK")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."k-mer analysis")
whatis("Description: ".."FastK based version of Merqury.")

-- Package settings
depends_on("R/4.3.1", "Other/FASTK/2025.06.07")
prepend_path("PATH", apphome.."/bin")
prepend_path("R_LIBS", apphome.."/lib/R")
__END__
