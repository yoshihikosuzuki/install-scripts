#!/bin/bash
module purge
set -eux
ml apptainer google-cloud-cli

MODROOT=/lustre12/home/yoshihiko_s-pg/app
APP=deepconsensus-gpu
VER=1.2.0

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR && cd $APPDIR

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
setenv("SINGULARITY_BIND", "/lustre12/home/yoshihiko_s-pg")
__END__
