#!/bin/bash
module purge
set -eu
set -x

MODROOT=/nfs/data05/yoshihiko_s/app
APP=repeatmasker
VER=4.1.9

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
# bash Miniforge3-$(uname)-$(uname -m).sh -b -p $APPDIR/$VER
cd $VER
# ./bin/mamba install -y -c bioconda -c free $APP=$VER
# rm -rf pkgs

# NOTE: Do the configuration manually
cd ${APPDIR}/${VER}/share/RepeatMasker
cd Libraries
# wget https://www.dfam.org/releases/Dfam_3.7/families/Dfam.h5.gz
# gunzip Dfam.h5.gz
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
