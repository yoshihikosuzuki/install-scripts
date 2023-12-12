#!/bin/bash
module purge
set -eux

MODROOT=/large/yoshihiko_s/app
APP=curl
VER=8.5.0

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

wget -O - https://curl.se/download/${APP}-${VER}.tar.gz | tar zxvf -
cd $APP-$VER
./configure --prefix=$APPDIR/$VER --without-ssl
make
make install
cd ..
rm -r $APP-$VER

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
