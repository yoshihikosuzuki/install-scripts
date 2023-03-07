#!/bin/bash
module purge
set -eux

module load singularity

MODROOT=/work/00/gg57/g57015/app
APP=deepvariant
VER=1.5.0

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR

singularity pull $APP.sif docker://google/$APP:$VER
for CMD in run_deepvariant make_examples call_variants postprocess_variants; do
    echo '#!/bin/sh' >$CMD
    echo "singularity exec $APPDIR/$APP.sif $CMD \$*" >>$CMD
    chmod +x $CMD
done

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", apphome)
setenv("SINGULARITY_BIND", "/work/00/gg57/g57015,/work/gg57/g57015,/work/00/gg57/share,/work/gg57/share")
__END__
