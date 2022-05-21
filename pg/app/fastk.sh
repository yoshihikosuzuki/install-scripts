#!/bin/bash
# Installed on CentOS 7
module purge
set -eux

module use /bio/package/.modulefiles
module load gcc/9.2.0

MODROOT=/hpgwork2/yoshihiko_s/app
APP=fastk
VER=2022.04.26

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

git clone https://github.com/thegenemyers/FASTK
mv FASTK $VER
cd $VER
make

cd $MODROOT/.modulefiles
mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", apphome)
execute {
    cmd = "OS_VER=\$(cat /etc/redhat-release | grep -oP '[0-9]+' | head -1); if [ \"\${OS_VER}\" == '6' ]; then printf \"\\\\033[0;33m [WARN]\\\\033[0m \"; echo \"Module " .. appname .. "/" .. appversion .. " does not work on CentOS 6\"; fi",
    modeA = { "load" }
}
__END__
