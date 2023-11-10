#!/bin/bash
module purge
set -eux

MODROOT=/nfs/data05/yoshihiko_s/app
APP=cactus
VER=2.6.12

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh -b -p $APPDIR/$VER
cd $VER
./bin/mamba install -y python=3.8
wget -O - https://github.com/ComparativeGenomicsToolkit/cactus/releases/download/v2.6.12/cactus-bin-v2.6.12.tar.gz | tar xzvf -

exit
# rm -rf pkgs

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", pathJoin(apphome, "bin"))
__END__
