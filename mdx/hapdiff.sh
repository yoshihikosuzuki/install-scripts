#!/bin/bash
module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/large/yoshihiko_s/app
APP=hapdiff
VER=0.9

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
mkdir -p $VER
cd $VER
singularity pull $APP.sif docker://mkolmogo/$APP:$VER
for CMD in hapdiff.py; do
    echo '#!/bin/sh' >$CMD
    echo "singularity exec $APPDIR/$VER/$APP.sif $CMD \$*" >>$CMD
    chmod +x $CMD
done
# NOTE: need `pip install altair`

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
setenv("SINGULARITY_BIND", "/home,/fast,/large")
__END__
