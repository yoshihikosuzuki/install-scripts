a#!/bin/bash
module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/lustre12/home/yoshihiko_s-pg/app
APP=go
VER=1.25.4

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
mkdir $VER
cd $VER
wget -O - https://go.dev/dl/go${VER}.linux-amd64.tar.gz | tar xzvf -

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("GOROOT", pathJoin(apphome, "go"))
prepend_path("GOPATH", pathJoin(apphome, ".go"))
prepend_path("PATH", pathJoin(apphome, "go/bin"))
prepend_path("PATH", pathJoin(apphome, ".go/bin"))
__END__
