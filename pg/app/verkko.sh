#!/bin/bash
module purge
set -eux

MODROOT=/hpgwork2/yoshihiko_s/app
APP=verkko
VER=1.0

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
# for FILE in *.py; do sed -i "s|#!/usr/bin/env python|#!${APPDIR}/${VER}/bin/python|" ${FILE}; done
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
execute {
    cmd = "OS_VER=\$(cat /etc/redhat-release | grep -oP '[0-9]+' | head -1); if [ \"\${OS_VER}\" == '6' ]; then printf \"\\\\033[0;33m [WARN]\\\\033[0m \"; echo \"Module " .. appname .. "/" .. appversion .. " does not work on CentOS 6\"; fi",
    modeA = { "load" }
}
__END__
