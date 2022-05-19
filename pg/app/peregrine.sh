#!/bin/bash
module purge

APP=peregrine
VER=1.6.3
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR

singularity pull $APP.sif docker://cschin/$APP:$VER
echo '#!/bin/sh' > $APP && echo "echo yes | singularity run $APPDIR/$APP.sif asm \$*" >> $APP && chmod +x $APP

cd $MODROOT/modulefiles/
mkdir -p $APP
cat <<__END__ > $APP/$VER.lua
-- Default settings
local modroot    = "/apps/unit/BioinfoUgrp"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package information
whatis("Name: "..appname)
whatis("Version: "..appversion)
whatis("URL: ".."https://github.com/cschin/Peregrine")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."assembly")
whatis("Description: ".."Fast Genome Assembler Using SHIMMER Index.")

-- Package settings
depends_on("singularity")
prepend_path("PATH", apphome)
__END__
