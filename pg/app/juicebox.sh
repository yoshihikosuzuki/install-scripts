#!/bin/bash
module purge
set -eux

MODROOT=/nfs/data05/yoshihiko_s/app
APP=juicebox
VER=2.13.07

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR && cd $APPDIR

wget https://github.com/aidenlab/Juicebox/releases/download/v.$VER/juicebox.jar
cat <<__END__ >juicebox
#!/bin/sh
java -jar -Xmx200G $APPDIR/juicebox.jar
__END__
chmod +x juicebox

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("java/11.0.14")
prepend_path("PATH", apphome)
__END__
