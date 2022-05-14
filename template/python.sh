#!/bin/bash
module purge
set -eux

# LOAD DEPENDENCIES IF NEEDED
module use /path/to/.modulefiles
module load python/VERSION

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=
APP=
VER=

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
# NOTE: Options for `tar` depend on the file type
wget -O - /path/to/tarball | tar xzvf -
# NOTE: `$APP-$VER` depends on the downloaded file name
mv $APP-$VER $VER && cd $VER && mkdir -p lib/pythonX.X/site-packages
# Case 1: Via setuptools
PYTHONUSERBASE=$(pwd) python setup.py install --user
# Case 2: Via pip (NOTE: Specify package names)
PYTHONUSERBASE=$(pwd) pip install --force-reinstall --user PACKAGES

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("python/VERSION")
prepend_path("PATH", pathJoin(apphome, "bin"))
prepend_path("PYTHONPATH", pathJoin(apphome, "lib/pythonX.X/site-packages"))
__END__
