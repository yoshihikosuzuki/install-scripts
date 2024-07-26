#!/bin/bash
module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data05/yoshihiko_s/app
APP=dorado
VER=0.7.2

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
wget -O - https://cdn.oxfordnanoportal.com/software/analysis/dorado-${VER}-linux-x64.tar.gz | tar zxvf -
mv dorado-${VER}-linux-x64 $VER

# NOTE: download models
#       `$ dorado basecaller ${DORADO_MODEL_DIR}/dna_r10.4.1_e8.2_400bps_${MODE}@v${MODEL_VER} ... (--modified-bases 5mCG_5hmCG)`
mkdir -p model
cd model
MODEL_VER=4.3.0
for MODE in fast hac sup; do
    wget https://cdn.oxfordnanoportal.com/software/analysis/dorado/dna_r10.4.1_e8.2_400bps_${MODE}@v${MODEL_VER}.zip
    unzip dna_r10.4.1_e8.2_400bps_${MODE}@v${MODEL_VER}.zip
    wget https://cdn.oxfordnanoportal.com/software/analysis/dorado/dna_r10.4.1_e8.2_400bps_${MODE}@v${MODEL_VER}_5mCG_5hmCG@v1.zip
    unzip dna_r10.4.1_e8.2_400bps_${MODE}@v${MODEL_VER}_5mCG_5hmCG@v1.zip
done
cd ..

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("gcc/9.2.0")
prepend_path("PATH", pathJoin(apphome, "bin"))
setenv("DORADO_MODEL_DIR", pathJoin(apphome, "model"))
__END__
