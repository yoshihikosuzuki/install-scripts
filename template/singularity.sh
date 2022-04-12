#!/bin/bash
set -eux

# LOAD DEPENDENCIES IF NEEDED
module load singularity/VERSION

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=
APP=
VER=

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
cd $VER
# If Docker container (NOTE: URL depends on the software):
singularity pull $APP.sif docker://google/$APP:$VER
# Make "stand-alone commands" (NOTE: replace the command names accordingly):
for CMD in XXX YYY; do
    echo '#!/bin/sh' >$CMD
    echo "singularity exec $APPDIR/$VER/$APP.sif $CMD \$*" >>$CMD
    chmod +x $CMD
done

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("singularity/VERSION")
prepend_path("PATH", apphome)
__END__
