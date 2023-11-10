#!/bin/bash
module purge
set -eux

module use /nfs/data05/yoshihiko_s/app/.modulefiles
module load gcc/9.2.0

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data05/yoshihiko_s/app
APP=liftoff
VER=1.6.3

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
CONDA_SH=Miniconda3-py37_4.9.2-Linux-x86_64.sh
curl -O https://repo.anaconda.com/miniconda/${CONDA_SH}
sh ${CONDA_SH} -b -p $APPDIR/$VER
rm ${CONDA_SH}
cd $VER
./bin/conda install -c bioconda -y liftoff=$VER
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
