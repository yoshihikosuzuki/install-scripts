#!/bin/bash
module purge
set -eux

## DEFINE WHERE TO INSTALL, APP NAME, AND VERSION
MODROOT=/nfs/data05/yoshihiko_s/app
APP=sratools
VER=3.2.1

APPDIR=$MODROOT/$APP
MODFILE_DIR=$MODROOT/.modulefiles/$APP

## DOWNLOAD SOURCE CODE, ETC., AND PREPARE `$APPDIR/$VER`
mkdir -p $APPDIR
cd $APPDIR
exit
wget -O - https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/${VER}/sratoolkit.${VER}-alma_linux64.tar.gz | tar xzvf -
mv sratoolkit.${VER}-alma_linux64 ${VER}

## INSTALL
# cd $VER

## MODULEFILE
mkdir -p $MODFILE_DIR && cd $MODFILE_DIR
cat <<__END__ >$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", pathJoin(apphome, "bin"))
__END__
