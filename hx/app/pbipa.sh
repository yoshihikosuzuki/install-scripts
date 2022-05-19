#!/bin/bash
module purge
set -eux

MODROOT=/work/yoshihiko_s/app
APP=pbipa
VER=1.3.2

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh ${CONDA_SH} -b -p $APPDIR/$VER
rm ${CONDA_SH}
cd $VER
./bin/conda config --add channels defaults
./bin/conda config --add channels conda-forge
./bin/conda config --add channels bioconda
./bin/conda config --set channel_priority strict
./bin/conda config --set allow_conda_downgrades true
./bin/conda install -y $APP=$VER

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
