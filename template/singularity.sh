#!/bin/bash
module purge
set -eux

## LOAD DEPENDENCIES IF NEEDED
module use /path/to/.modulefiles
module load singularity/xxx

## DEFINE WHERE TO INSTALL, APP NAME, AND VERSION
MODROOT=
APP=
VER=

APPDIR=$MODROOT/$APP
MODFILE_DIR=$MODROOT/.modulefiles/$APP

## DOWNLOAD SOURCE CODE, ETC., AND PREPARE `$APPDIR/$VER`
mkdir -p $APPDIR && cd $APPDIR

## INSTALL
mkdir -p $VER
cd $VER
singularity pull $APP.sif docker://google/$APP:$VER   # rename URL as appropriate
for CMD in xxx yyy; do
    cat <<__END__ >$CMD
#!/bin/bash
singularity exec $APPDIR/$VER/$APP.sif $CMD \$*
__END__
    chmod +x $CMD
done

## MODULEFILE
mkdir -p $MODFILE_DIR && cd $MODFILE_DIR
cat <<__END__ >$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("singularity/xxx")
prepend_path("PATH", apphome)
setenv("SINGULARITY_BIND", "")
__END__
