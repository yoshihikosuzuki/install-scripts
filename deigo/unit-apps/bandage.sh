#!/bin/bash
set -eu

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/hpcshare/appsunit/MyersU
APP=bandage
VER=0.8.1

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
mkdir $VER && cd $VER
wget https://github.com/rrwick/Bandage/releases/download/v$VER/Bandage_CentOS_static_v0_8_1.zip && unzip *.zip
cat <<__END__ >$APP
#!/bin/sh
LIBGL_ALWAYS_INDIRECT=1 $APPDIR/$VER/Bandage
__END__
chmod +x $APP

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", apphome)
__END__
