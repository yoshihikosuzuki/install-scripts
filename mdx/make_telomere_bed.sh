#!/bin/bash
module purge
set -eux

MODROOT=/large/yoshihiko_s/app
APP=make_telomere_bed
VER=2022.05.31

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

mkdir $VER
git clone https://github.com/yoshihikosuzuki/make_telomere_bed
cd make_telomere_bed
PYTHONUSERBASE=$APPDIR/$VER pip install --force-reinstall --user .

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on(atleast("python", "3"), "trf")
prepend_path("PATH", pathJoin(apphome, "bin"))
prepend_path("PYTHONPATH", pathJoin(apphome, "lib/python3.10/site-packages"))
__END__
