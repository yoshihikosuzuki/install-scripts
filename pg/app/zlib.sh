#!/bin/bash
module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data05/yoshihiko_s/app
APP=zlib
VER=1.2.3.6

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
# wget -O - https://zlib.net/fossils/zlib-$VER.tar.gz | tar xzvf -
mv ~/tmp/$APP-$VER.tar.gz .
tar xzvf $APP-$VER.tar.gz
mkdir $VER
cd $APP-$VER
./configure --prefix=$APPDIR/$VER
make
make install
cd ..
rm -r $APP-$VER

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
prepend_path("LD_LIBRARY_PATH", pathJoin(apphome, "lib"))
prepend_path("LDFLAGS", "-L" .. pathJoin(apphome, "lib"), " ")
prepend_path("CPATH", pathJoin(apphome, "include"))
prepend_path("CPPFLAGS", "-I" .. pathJoin(apphome, "include"), " ")
__END__
