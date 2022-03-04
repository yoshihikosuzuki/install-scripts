#!/bin/bash

module load singularity

APP=deepvariant
VER=1.1.0
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR

singularity pull $APP.sif docker://google/$APP:$VER
for CMD in run_deepvariant make_examples call_variants postprocess_variants; do echo '#!/bin/sh' > $CMD && echo "singularity exec $APPDIR/$APP.sif $CMD \$*" >> $CMD && chmod +x $CMD; done

cd $MODROOT/modulefiles/
mkdir -p $APP
cat <<'__END__' > $APP/$VER.lua
-- Default settings
local modroot    = "/apps/unit/BioinfoUgrp"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package information
whatis("Name: "..appname)
whatis("Version: "..appversion)
whatis("URL: ".."https://github.com/google/deepvariant")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."variant call")
whatis("Description: ".."DeepVariant is an analysis pipeline that uses a deep neural network to call genetic variants from next-generation DNA sequencing data.")

-- Package settings
depends_on("singularity")
prepend_path("PATH", apphome)
__END__
