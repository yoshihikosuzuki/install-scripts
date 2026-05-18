#!/bin/bash
module purge
module load python/3.10.14
set -eux

MODROOT=/nfs/data05/yoshihiko_s/app
APP=motifscope
VER=2025.05.26

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

mkdir -p $VER
cd $VER

cd ..
# git clone https://github.com/yoshihikosuzuki/MotifScope
cd MotifScope
PYTHONUSERBASE=$APPDIR/$VER pip install --user --force-reinstall ./install/conda

PYTHONUSERBASE=$APPDIR/$VER python -m pip install --user --force-reinstall \
    numpy==1.26.4 \
    pandas \
    matplotlib \
    biopython \
    multiprocess \
    umap-learn \
    scikit-learn \
    levenshtein \
    scipy==1.13.0 \
    pyabpoa==1.5.3

cd ..
# git clone https://github.com/holstegelab/pylibsais.git
cd pylibsais
# PYTHONUSERBASE=$APPDIR/$VER python setup.py build
PYTHONUSERBASE=$APPDIR/$VER pip install --user --force-reinstall .

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("python/3.10")
prepend_path("PATH", pathJoin(apphome, "bin"))
prepend_path("PYTHONPATH", pathJoin(apphome, "lib/python3.10/site-packages"))
__END__
