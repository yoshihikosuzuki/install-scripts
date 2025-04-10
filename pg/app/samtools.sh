#!/bin/bash
module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data05/yoshihiko_s/app
APP=samtools
VER=1.18

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
# bash Miniforge3-$(uname)-$(uname -m).sh -b -p $APPDIR/$VER
# cd $VER
# ./bin/mamba install -c bioconda -y $APP=$VER
# rm -rf pkgs

CONDA_SH=Miniconda3-py37_4.9.2-Linux-x86_64.sh
curl -O https://repo.anaconda.com/miniconda/${CONDA_SH}
sh ${CONDA_SH} -b -p $APPDIR/$VER
rm ${CONDA_SH}
cd $VER
./bin/conda install -c defaults -c conda-forge -c bioconda -y $APP=$VER
rm -rf pkgs

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
# wget -O - https://github.com/samtools/$APP/releases/download/$VER/$APP-$VER.tar.bz2 | tar xjvf -
# mkdir $VER
# cd $APP-$VER
# ./configure --prefix=$APPDIR/$VER
# make
# make install
# cd ..
# rm -r $APP-$VER

# WRITE A MODULEFILE
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
