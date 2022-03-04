#!/bin/bash

APP=3d-dna
VER=180922
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

git clone https://github.com/aidenlab/3d-dna
mv 3d-dna $VER && cd $VER
ln -sf run-asm-pipeline.sh 3d-dna
ln -sf run-asm-pipeline-post-review.sh 3d-dna-post-review
cd visualize/ && ln -sf run-assembly-visualizer.sh 3d-dna-run-assembly-visualizer && cd ..
CMD=3d-dna-fasta2assembly
echo '#!/bin/sh' > $CMD && echo "awk -f $APPDIR/$VER/utils/generate-assembly-file-from-fasta.awk \$*" >> $CMD
chmod +x *.sh */*.sh $CMD

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
whatis("URL: ".."https://github.com/aidenlab/3d-dna")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."Hi-C, scaffolding")
whatis("Description: ".."3D de novo assembly (3D DNA) pipeline.")

-- Package settings
depends_on("bwa", "Other/bioawk", "Other/parallel", "Other/juicer")
prepend_path("PATH", apphome)
prepend_path("PATH", apphome.."/visualize")
__END__
