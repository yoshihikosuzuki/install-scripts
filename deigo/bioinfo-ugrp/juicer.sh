#!/bin/bash

APP=juicer
VER=1.6
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR

wget -O - https://github.com/aidenlab/juicer/archive/refs/tags/$VER.tar.gz | tar xzvf -
mv $APP-$VER/CPU scripts && mv $APP-$VER/misc/* . && rm -rf scripts/README.md $APP-$VER
sed -i 's|juiceDir="/opt/juicer"|juiceDir="."|' scripts/juicer.sh
CMD=juicer_copy_scripts_dir
echo '#!/bin/sh' > $CMD && echo "ln -sf $APPDIR/scripts/ ." >> $CMD
chmod +x * scripts/common/*
cd scripts/common && wget https://s3.amazonaws.com/hicfiles.tc4ga.com/public/juicer/juicer_tools_1.22.01.jar && ln -sf juicer_tools_1.22.01.jar juicer_tools.jar

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
whatis("URL: ".."https://github.com/aidenlab/juicer")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."Hi-C, scaffolding")
whatis("Description: ".."A One-Click System for Analyzing Loop-Resolution Hi-C Experiments.")

-- Package settings
depends_on("java-jdk/14", "bwa")
prepend_path("PATH", apphome)
__END__
