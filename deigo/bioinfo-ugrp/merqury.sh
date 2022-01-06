#!/bin.bash

module load R/4.0.4

APP=merqury
VER=1.3
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

wget -O - https://github.com/marbl/merqury/archive/refs/tags/v$VER.tar.gz | tar zxvf -
mv $APP-$VER $VER && cd $VER
sed -i 's/echo $?/echo 1/' util/util.sh
for FILE in plot/*.R; do sed -i 's|#!/usr/bin/env Rscript|#!/usr/bin/env -S Rscript --vanilla|'
mkdir -p lib/R && Rscript -e 'install.packages(c("argparse","R6","jsonlite","findpython","ggplot2","scales"), lib="./lib/R")'

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
whatis("URL: ".."https://github.com/marbl/merqury")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."assembly")
whatis("Description: ".."k-mer based assembly evaluation.")

-- Package settings
depends_on("R/4.0.4", "samtools/1.12", "bedtools/v2.29.2", "Other/meryl/1.3")
prepend_path("PATH", apphome)
prepend_path("R_LIBS", apphome.."/lib/R")
setenv("MERQURY", apphome)
__END__
