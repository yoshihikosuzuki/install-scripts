#!/bin/bash
module purge
set -eu
module load go
set -x

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/lustre12/home/yoshihiko_s-pg/app
APP=apptainer
VER=1.4.4

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
wget -O - https://github.com/apptainer/apptainer/releases/download/v${VER}/${APP}-${VER}.tar.gz | tar xzvf -
mkdir $VER
cd ${APP}-${VER}
./mconfig \
  --prefix=$APPDIR/$VER \
  --without-suid
cd builddir
make -j4
make install
cd ..
rm -rf ${APP}-${VER}

## NOTE: sif は　 docker 経由で作る？
# docker run --rm -v "$PWD":/work \
#   quay.io/apptainer/apptainer:latest \
#   build /work/ubuntu_22.04.sif docker://ubuntu:22.04
# apptainer shell ubuntu_22.04.sif

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
