#!/bin/bash
module purge
set -eux

module use /work/00/gg57/g57015/app/.modulefiles
module load python/3.8.15

MODROOT=/work/00/gg57/share/yoshi-tools
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
prepend_path("PYTHONPATH", pathJoin(apphome, "lib/python3.8/site-packages"))
__END__
