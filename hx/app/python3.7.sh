#!/bin/bash
set -eux

module load gcc/9.3.0 openssl/1.1.1 libffi/3.4.2 libsqlite3/3380500

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/work/yoshihiko_s/app
APP=python
VER=3.7.13

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
git clone https://github.com/python/cpython
cd cpython
git checkout 3.7
./configure --prefix $APPDIR/$VER --with-ensurepip=install --with-openssl=$OPENSSL_PATH --enable-optimizations
make
make install
cd ..
rm -rf cpython

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
prepend_path("PATH", pathJoin(apphome, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(apphome, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(apphome, "lib"))
prepend_path("LDFLAGS", "-L" .. pathJoin(apphome, "lib"), " ")
prepend_path("CPATH", pathJoin(apphome, "include"))
prepend_path("CPPFLAGS", "-I" .. pathJoin(apphome, "include"), " ")
__END__
