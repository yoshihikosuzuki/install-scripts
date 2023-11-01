#!/bin/bash
module purge
set -eux

MODROOT=/nfs/data05/yoshihiko_s/app
APP=ete
VER=3.1.3

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

CONDA_SH=Miniconda3-4.3.11-Linux-x86_64.sh
curl -O https://repo.anaconda.com/miniconda/${CONDA_SH}
sh ${CONDA_SH} -b -p $APPDIR/$VER
rm ${CONDA_SH}
cd $VER
./bin/conda install -c conda-forge -y mamba
# ./bin/mamba install -c etetoolkit -y $APP=$VER ete_toolchain
# ./bin/ete3 build check
./bin/pip install https://github.com/etetoolkit/ete/archive/ete4.zip   # TODO: try do only this
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
