#!/bin/bash
module purge
set -eux

MODROOT=/nfs/data05/yoshihiko_s/app
APP=deepconsensus-gpu
VER=1.2.0

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR

singularity pull $APP.sif docker://google/deepconsensus:$VER-gpu
mkdir -p model
gsutil cp -r gs://brain-genomics-public/research/deepconsensus/models/v1.2/model_checkpoint/* model/
for CMD in deepconsensus; do
    echo '#!/bin/sh' >$CMD
    echo "singularity exec $APPDIR/$APP.sif $CMD --checkpoint=$APPDIR/model/checkpoint \$*" >>$CMD
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
unsetenv("PERL5LIB")
setenv("PERL_BADLANG", "0")
setenv("APPTAINER_BIND", "/data,/grid2,/nfs/data02,/nfs/data03,/nfs/data04,/nfs/data05,/nfs/data06,/nfs/data07,/nfs/data08,/nfs/data09")
__END__
