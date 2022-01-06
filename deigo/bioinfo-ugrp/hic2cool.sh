#!/bin.bash

module load python/3.7.3

APP=hic2cool
VER=0.8.3
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

wget -O - https://github.com/4dn-dcic/hic2cool/archive/refs/tags/$VER.tar.gz | tar xzvf -
mv $APP-$VER $VER && cd $VER
mkdir -p lib/python3.7/site-packages
sed -i 's|    name = "hic2cool",|    name = "hic2cool",\n    zip_safe = False,|' setup.py
PYTHONUSERBASE=$(pwd) python setup.py install --user
PYTHONUSERBASE=$(pwd) pip install -r requirements.txt --force-reinstall --user

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
whatis("URL: ".."https://github.com/4dn-dcic/hic2cool")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."Hi-C")
whatis("Description: ".."Lightweight converter between hic and cool contact matrices.")

-- Package settings
depends_on("python/3.7.3")
prepend_path("PATH", apphome.."/bin")
prepend_path("PYTHONPATH", apphome.."/lib/python3.7/site-packages")
__END__
