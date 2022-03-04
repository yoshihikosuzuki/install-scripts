#!/bin/bash

APP=juicebox
VER=2.13.07
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR

wget https://github.com/aidenlab/Juicebox/releases/download/v.$VER/juicebox.jar
CMD=juicebox
echo '#!/bin/sh' > $CMD && echo "java -jar -Xmx500G $APPDIR/juicebox.jar" >> $CMD
chmod +x $CMD

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
whatis("URL: ".."https://github.com/aidenlab/Juicebox")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."Hi-C, scaffolding")
whatis("Description: ".."Visualization and analysis software for Hi-C data.")

-- Package settings
depends_on("java-jdk/14")
prepend_path("PATH", apphome)
__END__
