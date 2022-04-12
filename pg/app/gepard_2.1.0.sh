#!/bin/bash
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

PG_DIR=$HOME/tmp

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/hpgwork2/yoshihiko_s/app
APP=gepard
VER=2.1.0

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
wget -O - https://github.com/univieCUBE/$APP/archive/refs/tags/v$VER.tar.gz | tar xzvf -
mv $APP-$VER $VER && cd $VER
cat <<__END__ >$APP
#!/bin/sh
java -cp $APPDIR/$VER/dist/Gepard-2.1.jar org.gepard.client.cmdline.CommandLine -matrix $APPDIR/$VER/resources/matrices/edna.mat \$*
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
setenv("GEPARD_ROOT", apphome)
__END__
