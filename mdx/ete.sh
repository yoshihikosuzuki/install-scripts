#!/bin/bash
module purge
set -eux

MODROOT=/large/yoshihiko_s/app
APP=ete
VER=4.0.0

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# CONDA_SH=Miniconda3-4.3.11-Linux-x86_64.sh
# curl -O https://repo.anaconda.com/miniconda/${CONDA_SH}
# bash ${CONDA_SH} -b -p $APPDIR/$VER
# rm ${CONDA_SH}
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh -b -p $APPDIR/$VER
cd $VER
# ./bin/conda install -c conda-forge -y mamba
# ./bin/mamba install -c etetoolkit -y ete3 ete_toolchain
# ./bin/ete3 build check
PYTHONUSERBASE=$(pwd) ./bin/pip install --user --force-reinstall https://github.com/etetoolkit/ete/archive/ete4.zip
./bin/ete4 build check
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
