#!/bin/bash
module purge
set -eux

MODROOT=/nfs/data05/yoshihiko_s/app
APP=agat
VER=1.2.0

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

CONDA_SH=Miniconda3-py39_23.5.2-0-Linux-x86_64.sh
curl -O https://repo.anaconda.com/miniconda/${CONDA_SH}
sh ${CONDA_SH} -b -p $APPDIR/$VER
rm ${CONDA_SH}
cd $VER
# ./bin/conda install -c conda-forge -y mamba=1.5.1
# ./bin/mamba install -c conda-forge -c bioconda -y $APP=$VER
./bin/conda install -c conda-forge -c bioconda -y $APP=$VER
rm -rf pkgs

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
