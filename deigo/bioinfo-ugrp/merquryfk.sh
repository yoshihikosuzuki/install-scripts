#!/bin.bash

module load R/4.0.4

APP=MerquryFK
VER=2021.09.14
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

git clone https://github.com/thegenemyers/MERQURY.FK
mv MERQURY.FK $VER && cd $VER
mkdir -p lib/R && Rscript -e 'install.packages(c("argparse","R6","jsonlite","findpython","ggplot2","scales","cowplot","viridis"), lib="./lib/R")'
for FILE in KatComp.c KatGC.c PloidyPlot.c asm_plotter.c cn_plotter.c; do sed -i 's|Rscript|Rscript --vanilla|' $FILE; done
for FILE in *.h; do sed -i 's|#!/usr/bin/env Rscript|#!/usr/bin/env -S Rscript --vanilla|' $FILE; done
make && mkdir -p bin && mv CNplot ASMplot CNspectra KatComp KatGC PloidyPlot bin/

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
whatis("URL: ".."https://github.com/thegenemyers/MERQURY.FK")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."k-mer analysis")
whatis("Description: ".."FastK based version of Merqury.")

-- Package settings
depends_on("R/4.0.4", "Other/FASTK")
prepend_path("PATH", apphome.."/bin")
prepend_path("R_LIBS", apphome.."/lib/R")
__END__
