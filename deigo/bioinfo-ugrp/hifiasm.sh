#!/bin.bash

APP=hifiasm
VER=0.15.4
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

wget -O - https://github.com/chhylp123/hifiasm/archive/refs/tags/$VER.tar.gz | tar xzvf -
mv $APP-$VER $VER
cd $VER && make

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
whatis("URL: ".."https://github.com/chhylp123/hifiasm")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."PacBio, hifi, assembly")
whatis("Description: ".."Hifiasm: a haplotype-resolved assembler for accurate Hifi reads.")

-- Package settings
prepend_path("PATH", apphome)
__END__
