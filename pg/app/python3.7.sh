#!/bin/bash
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/hpgwork2/yoshihiko_s/app
APP=python
VER=3.7.12

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
# NOTE: Needed to ensure that there is no python Lmod module previously installed;
#       Otherwise `make install` does not install `setuptools` and `pip`.
git clone https://github.com/python/cpython && cd cpython && git checkout 3.7
./configure --prefix $APPDIR/$VER --with-ensurepip=install && make && make install
cd .. && rm -rf cpython
cd $VER/bin && ln -sf python3 python && ln -sf pip3.7 pip3 && ln -sf pip3 pip

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
__END__
