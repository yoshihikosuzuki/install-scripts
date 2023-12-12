#!/bin/bash
module purge
set -eux

MODROOT=/large/yoshihiko_s/app
APP=juicer
VER=1.6

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR && cd $APPDIR

wget -O - https://github.com/aidenlab/juicer/archive/refs/tags/$VER.tar.gz | tar xzvf -
mv $APP-$VER/CPU scripts
mv $APP-$VER/misc/* .
rm -rf scripts/README.md $APP-$VER
sed -i 's|juiceDir="/opt/juicer"|juiceDir="."|' scripts/juicer.sh
cat <<__END__ >juicer_copy_scripts_dir
#!/bin/sh
ln -sf $APPDIR/scripts/ .
__END__
chmod +x * scripts/common/*
cd scripts/common
wget https://s3.amazonaws.com/hicfiles.tc4ga.com/public/juicer/juicer_tools_1.22.01.jar
ln -sf juicer_tools_1.22.01.jar juicer_tools.jar

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on(atleast("java", "11"), "bwa")
prepend_path("PATH", apphome)
__END__
