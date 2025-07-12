#!/bin/bash
module purge
set -eux
ml google-cloud-cli

MODROOT=/large/yoshihiko_s/app
APP=deepconsensus
VER=1.2.0

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR


singularity pull $APP.sif docker://google/$APP:$VER
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
setenv("SINGULARITY_BIND", "/home,/fast,/large")
__END__
