#!/bin/bash
module purge
set -eu
set -x

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/work/00/gg57/g57015/app
APP=openssl
VER=1.1.1

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
wget -O - https://github.com/openssl/openssl/archive/refs/tags/OpenSSL_1_1_1n.tar.gz | tar xzvf -
mkdir $VER
cd openssl-OpenSSL_1_1_1n
./config --prefix=$APPDIR/$VER --openssldir=$APPDIR/$VER/ssl
make
make install
cd ..
rm -r openssl-OpenSSL_1_1_1n

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
prepend_path("LIBRARY_PATH", pathJoin(apphome, "lib"))
prepend_path("LDFLAGS", "-L" .. pathJoin(apphome, "lib"), " ")
prepend_path("CPATH", pathJoin(apphome, "include"))
prepend_path("CPPFLAGS", "-I" .. pathJoin(apphome, "include"), " ")
prepend_path("OPENSSL_PATH", apphome)
__END__
