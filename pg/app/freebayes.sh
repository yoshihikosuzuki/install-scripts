#!/bin/bash
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/hpgwork2/yoshihiko_s/app
APP=freebayes
VER=1.3.5

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh -b -p $VER && rm Miniconda3-latest-Linux-x86_64.sh
cd $VER
./bin/conda config --add channels defaults
./bin/conda config --add channels conda-forge
./bin/conda config --add channels bioconda
./bin/conda install -y $APP=$VER
rm -rf pkgs

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
