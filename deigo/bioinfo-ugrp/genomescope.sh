#!/bin.bash

module load R/4.0.4

APP=genomescope
VER=2.0
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

git clone https://github.com/tbenavi1/genomescope2.0
mv genomescope2.0 $VER && cd $VER
mkdir -p lib/R && sed -i 's|local_lib_path = "~/R_libs/"|local_lib_path = "./lib/R"|' install.R && Rscript install.R
Rscript -e 'install.packages(c("R6", "jsonlite", "findpython"), lib="./lib/R")'
sed -i 's|#!/usr/bin/env Rscript|#!/usr/bin/env -S Rscript --vanilla|' genomescope.R
mkdir -p bin && mv genomescope.R bin/

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
whatis("URL: ".."https://github.com/tbenavi1/genomescope2.0")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."sequencing")
whatis("Description: ".."Reference-free profiling of polyploid genomes.")

-- Package settings
depends_on("R/4.0.4", "Other/KMC/genomescope")
prepend_path("PATH", apphome.."/bin")
prepend_path("R_LIBS", apphome.."/lib/R")
__END__
