#!/bin/bash
set -eu
module load java-jdk/21

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/hpcshare/appsunit/MyersU
APP=nextflow
VER=23.10.1

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
mkdir $VER && cd $VER
curl -fsSL https://get.nextflow.io | bash

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("java-jdk/21")
prepend_path("PATH", apphome)
__END__
