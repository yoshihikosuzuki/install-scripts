#!/bin/bash
module purge
set -eux

MODROOT=/large/yoshihiko_s/app
APP=verkko
VER=2.3.2

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh -b -p $APPDIR/$VER
# CONDA_SH=Miniconda3-py39_24.1.2-0-Linux-x86_64.sh
# curl -O https://repo.anaconda.com/miniconda/${CONDA_SH}
# bash ${CONDA_SH} -b -p $APPDIR/$VER
# rm ${CONDA_SH}
cd $VER
./bin/mamba install -c conda-forge -c bioconda -c defaults -y $APP=$VER
rm -rf pkgs

cd lib/verkko
cd scripts
for FILE in *.py; do
    sed -i "s|#\!/usr/bin/env python|#\!${APPDIR}/${VER}/bin/python|" ${FILE}
done
cd ..
# cd profiles
# -q centos7.q, -pe smp, -l mem_total={mem_gb}G    in `slurm-sge-submit.sh`

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
