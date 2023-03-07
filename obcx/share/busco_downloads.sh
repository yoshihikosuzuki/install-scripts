#!/bin/bash
module purge
set -eux

MODROOT=/work/00/gg57/share/yoshi-tools
APP=busco_downloads
VER=5_2023.01.30

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR && cd $APPDIR

wget --no-check-certificate -r https://busco-data.ezlab.org/v5/data/
mv busco-data.ezlab.org/v5/data/* .
rm -r busco-data.ezlab.org/
cd lineages
for FILE in *.tar.gz; do
    tar xzvf $FILE
done

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ > $APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
setenv("BUSCO_DOWNLOADS", apphome)
__END__
