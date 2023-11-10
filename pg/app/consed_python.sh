#!/bin/bash
module purge
set -eux

module use /nfs/data05/yoshihiko_s/app/.modulefiles
module load python/3.8.13

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data05/yoshihiko_s/app
APP=consed_python
VER=2019

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
mkdir $VER
git clone https://github.com/yoshihikosuzuki/consed_python
cd consed_python
make
PYTHONUSERBASE=$APPDIR/$VER pip install --force-reinstall --user .

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on(atleast("python", "3"))
prepend_path("PYTHONPATH", pathJoin(apphome, "lib/python3.8/site-packages"))
__END__
