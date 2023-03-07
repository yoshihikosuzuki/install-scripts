#!/bin/bash
module purge
set -eux

MODROOT=/work/00/gg57/share/yoshi-tools
APP=picard
VER=2.27.1

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

mkdir $VER && cd $VER
wget https://github.com/broadinstitute/picard/releases/download/$VER/picard.jar
CMD=picard
cat <<__END__ > $CMD
#!/bin/bash
java -jar $APPDIR/$VER/picard.jar \$*
__END__
chmod +x $CMD

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", apphome)
prepend_path("PICARD", pathJoin(apphome, "picard.jar"))
__END__
