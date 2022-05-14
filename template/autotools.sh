#!/bin/bash
module purge
set -eux

# LOAD DEPENDENCIES IF NEEDED
module use /path/to/.modulefiles
module load XXX

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
mkdir $VER && cd $APP-$VER
./configure --prefix=$APPDIR/$VER && make && make install
cd .. && rm -r $APP-$VER

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("XXX")
prepend_path("PATH", pathJoin(apphome, "bin"))
prepend_path("LIBRARY_PATH", pathJoin(apphome, "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(apphome, "lib"))
prepend_path("CPATH", pathJoin(apphome, "include"))
__END__
