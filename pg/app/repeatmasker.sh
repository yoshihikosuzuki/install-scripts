#!/bin/bash
module purge
set -eu
set -x

MODROOT=/nfs/data05/yoshihiko_s/app
APP=repeatmasker
VER=4.1.7

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

CONDA_SH=Miniconda3-py37_4.9.2-Linux-x86_64.sh
curl -O https://repo.anaconda.com/miniconda/${CONDA_SH}
sh ${CONDA_SH} -b -p $APPDIR/$VER
rm ${CONDA_SH}
cd $VER
./bin/conda install -y -c bioconda -c free $APP=$VER
rm -rf pkgs

# NOTE: Do the configuration manually
cd ${APPDIR}/${VER}/share/RepeatMasker
cd Libraries
wget https://www.dfam.org/releases/Dfam_3.7/families/Dfam.h5.gz
gunzip Dfam.h5.gz
# or,
# wget https://www.dfam.org/releases/Dfam_3.7/families/Dfam_curatedonly.h5.gz
# gunzip Dfam_curatedonly.h5.gz
# ln -sf Dfam_curatedonly.h5 Dfam.h5
cd ..
source ../../bin/activate
perl ./configure

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("bzip2")
prepend_path("PATH", pathJoin(apphome, "bin"))
__END__
