#!/bin/bash
module purge
set -eu
unset PYTHONPATH
unset CONDA_PREFIX
# module load python/3.8.15
set -x

MODROOT=/work/00/gg57/share/yoshi-tools
# MODROOT=/work/00/gg57/g57015/app-hoge
APP=repeatmasker
VER=4.1.2.p1

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

CONDA_SH=Miniconda3-py37_4.9.2-Linux-x86_64.sh
curl -O https://repo.anaconda.com/miniconda/${CONDA_SH}
sh ${CONDA_SH} -b -p $APPDIR/$VER
rm ${CONDA_SH}
cd $VER
./bin/conda install -y -c bioconda -c free $APP=$VER
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
