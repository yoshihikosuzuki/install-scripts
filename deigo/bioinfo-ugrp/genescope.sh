#!/bin.bash

module load R/4.0.4

APP=genescope
VER=2021.03.26
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

git clone https://github.com/thegenemyers/GENESCOPE.FK
mv GENESCOPE.FK $VER && cd $VER
mkdir -p lib/R && cat <<'__END__' > install.R
local_lib_path = "./lib/R"
install.packages('minpack.lm', lib=local_lib_path)
install.packages('argparse', lib=local_lib_path)
install.packages('.', repos=NULL, type="source", lib=local_lib_path)
__END__
Rscript install.R
Rscript -e 'install.packages(c("R6", "jsonlite", "findpython"), lib="./lib/R")'
sed -i 's|#!/usr/bin/env Rscript|#!/usr/bin/env -S Rscript --vanilla|' GeneScopeFK.R
mkdir -p bin && mv GeneScopeFK.R bin/

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
whatis("URL: ".."https://github.com/thegenemyers/GENESCOPE.FK")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."sequencing, k-mer analysis")
whatis("Description: ".."A derivative of GenomeScope2.0 modified to work with FastK.")

-- Package settings
depends_on("R/4.0.4", "Other/FASTK")
prepend_path("PATH", apphome.."/bin")
prepend_path("R_LIBS", apphome.."/lib/R")
__END__
