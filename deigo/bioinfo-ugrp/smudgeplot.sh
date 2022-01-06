#!/bin.bash

module load R/4.0.4

APP=smudgeplot
VER=0.2.3
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

git clone https://github.com/KamilSJaron/smudgeplot
mv smudgeplot $VER && cd $VER
mkdir -p lib/R && Rscript -e 'install.packages(c("devtools","argparse","R6","jsonlite","findpython","viridis"), lib="./lib/R")'
sed -i '1ilocal_lib_path = "./lib/R"' install.R && sed -i 's|install.packages(".", repos = NULL, type="source")|install.packages(".", repos = NULL, type="source", lib=local_lib_path)|' install.R
R_LIBS=./lib/R Rscript install.R && unset R_LIBS
sed -i 's|#!/usr/bin/env Rscript|#!/usr/bin/env -S Rscript --vanilla|' exec/smudgeplot_plot.R

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
whatis("URL: ".."https://github.com/KamilSJaron/smudgeplot")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."qc, sequencing")
whatis("Description: ".."Inference of ploidy and heterozygosity structure using whole genome sequencing data.")

-- Package settings
depends_on("R/4.0.4", "Other/KMC/genomescope", "Other/genomescope/2.0")
prepend_path("PATH", apphome.."/exec")
prepend_path("R_LIBS", apphome.."/lib/R")
__END__
