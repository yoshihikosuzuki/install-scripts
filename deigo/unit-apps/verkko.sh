#!/bin/bash
set -eu

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/hpcshare/appsunit/MyersU
APP=verkko
VER=2.0

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
CONDA_SH=Miniconda3-py39_23.5.2-0-Linux-x86_64.sh
curl -O https://repo.anaconda.com/miniconda/${CONDA_SH}
sh ${CONDA_SH} -b -p $APPDIR/$VER
rm ${CONDA_SH}
cd $VER
./bin/conda install -c conda-forge -c bioconda -c defaults -y $APP=$VER
rm -rf pkgs

cd lib/verkko
cd scripts
for FILE in *.py; do sed -i "s|#\!/usr/bin/env python|#\!${APPDIR}/${VER}/bin/python|" ${FILE}; done
cd ..
# cd profiles
# -q centos7.q, -pe smp, -l mem_total={mem_gb}G    in `slurm-sge-submit.sh`

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
