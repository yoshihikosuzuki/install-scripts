#!/bin/bash
module purge
set -eux

module use /bio/package/.modulefiles
module load gcc/9.3.0

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/work/yoshihiko_s/app
APP=libffi
VER=3.4.2

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
wget --no-check-certificate -O - https://github.com/libffi/libffi/releases/download/v$VER/libffi-$VER.tar.gz | tar xzvf -
mkdir $VER
cd libffi-$VER
./configure --prefix=$APPDIR/$VER
make
make install
cd ..
rm -r libffi-$VER

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("gcc/9.3.0")
prepend_path("LD_LIBRARY_PATH", pathJoin(apphome, "lib64"))
prepend_path("LIBRARY_PATH", pathJoin(apphome, "lib64"))
prepend_path("LDFLAGS", "-L" .. pathJoin(apphome, "lib64"), " ")
prepend_path("CPATH", pathJoin(apphome, "include"))
prepend_path("CPPFLAGS", "-I" .. pathJoin(apphome, "include"), " ")
__END__
