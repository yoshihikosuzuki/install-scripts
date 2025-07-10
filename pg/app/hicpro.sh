#!/bin/bash
module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data05/yoshihiko_s/app
APP=hicpro
VER=3.0.0

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
mkdir -p $VER
cd $VER
singularity pull $APP.sif docker://nservant/${APP}:${VER}
for CMD in HiC-Pro; do
    echo '#!/bin/sh' >$CMD
    echo "singularity exec $APPDIR/$VER/$APP.sif /HiC-Pro_${VER}/bin/$CMD \$*" >>$CMD
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
prepend_path("PATH", apphome)
unsetenv("PERL5LIB")
setenv("PERL_BADLANG", "0")
setenv("APPTAINER_BIND", "/data,/grid2,/nfs/data02,/nfs/data03,/nfs/data04,/nfs/data05,/nfs/data06,/nfs/data07,/nfs/data08")
__END__
