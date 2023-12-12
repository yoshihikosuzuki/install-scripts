#!/bin/bash
module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/large/yoshihiko_s/app
APP=picard
VER=3.1.1

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
mkdir $VER && cd $VER
wget https://github.com/broadinstitute/picard/releases/download/$VER/picard.jar
CMD=picard
cat <<__END__ > $CMD
#!/bin/bash
java -jar $APPDIR/$VER/picard.jar \$*
__END__
chmod +x $CMD

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on(atleast("java", "17"))
prepend_path("PATH", apphome)
prepend_path("PICARD", pathJoin(apphome, "picard.jar"))
__END__
