#!/bin/bash
module purge
set -eux

module use /work/yoshihiko_s/app/.modulefiles
module load python/3.7.13

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/work/yoshihiko_s/app
APP=plotly_light
VER=1.0.4

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
mkdir $VER
cd $VER
PYTHONUSERBASE=$(pwd) pip install --force-reinstall --user plotly-light==$VER

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on(atleast("python", "3.7"))
prepend_path("PYTHONPATH", pathJoin(apphome, "lib/python3.7/site-packages"))
__END__
