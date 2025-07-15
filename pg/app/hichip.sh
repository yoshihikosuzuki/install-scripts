#!/bin/bash
module purge
set -eux

MODROOT=/nfs/data05/yoshihiko_s/app
APP=hichip
VER=2024.03.13

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

git clone https://github.com/dovetail-genomics/HiChiP
mv HiChiP $VER
cd $VER
chmod +x *.sh *.py
PYTHONUSERBASE=$(pwd) pip install --user --force-reinstall tabulate
PYTHONUSERBASE=$(pwd) pip install --user --force-reinstall numpy matplotlib pandas

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on(atleast("python", "3"), "samtools", "bedtools")
prepend_path("PATH", apphome)
prepend_path("PYTHONPATH", pathJoin(apphome, "lib/python3.10/site-packages"))
__END__
