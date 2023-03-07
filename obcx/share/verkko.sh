#!/bin/bash
module purge
set -eux

MODROOT=/work/00/gg57/share/yoshi-tools
APP=verkko
VER=1.2

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

CONDA_SH=Miniconda3-py37_4.9.2-Linux-x86_64.sh
curl -O https://repo.anaconda.com/miniconda/${CONDA_SH}
sh ${CONDA_SH} -b -p $APPDIR/$VER
rm ${CONDA_SH}
cd $VER
./bin/conda install -c conda-forge -c bioconda -c defaults -y $APP=$VER
rm -rf pkgs

cd lib/verkko
cd scripts
for FILE in *.py; do sed -i "s|#!/usr/bin/env python|#!${APPDIR}/${VER}/bin/python|" ${FILE}; done
cd ..
cd profiles
# -q centos7.q, -pe smp, -l mem_total={mem_gb}G    in `slurm-sge-submit.sh`

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("snakemake")
prepend_path("PATH", pathJoin(apphome, "bin"))
__END__
