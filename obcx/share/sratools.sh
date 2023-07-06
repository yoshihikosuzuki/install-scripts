#!/bin/bash
module purge
set -eux

MODROOT=/work/00/gg57/share/yoshi-tools
APP=sratools
VER=3.0.2

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

wget -O - https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/${VER}/sratoolkit.${VER}-centos_linux64.tar.gz | tar xzvf -
mv sratoolkit.${VER}-centos_linux64 ${VER}

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
