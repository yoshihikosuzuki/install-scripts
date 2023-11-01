#!/bin/bash
module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data05/yoshihiko_s/app
APP=cromwell
VER=86

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
mkdir $VER && cd $VER
wget https://github.com/broadinstitute/cromwell/releases/download/${VER}/cromwell-${VER}.jar

CMD=cromwell
cat <<__END__ >$CMD
#!/bin/bash
java -jar $APPDIR/$VER/cromwell-${VER}.jar \$*
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
depends_on("java/11")
prepend_path("PATH", apphome)
__END__
