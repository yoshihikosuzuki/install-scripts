#!/bin/bash

module load singularity/3.5.2

APP=BUSCO
VER=5.1.3
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR

singularity pull busco.sif docker://ezlabgva/busco:v${VER}_cv1
echo -e '#!/bin/bash\n'"singularity exec -B \$(pwd):/busco_wd/ $APPDIR/busco.sif \$*" > busco_sif && chmod +x busco_sif
echo -e '#!/bin/bash\n'"export SINGULARITYENV_AUGUSTUS_CONFIG_PATH=\$(pwd)/augustus_config\necho "\""Copying Augustus config dir to \${SINGULARITYENV_AUGUSTUS_CONFIG_PATH}"\""\nrm -rf \${SINGULARITYENV_AUGUSTUS_CONFIG_PATH}\nbusco_sif cp -r /augustus/config \${SINGULARITYENV_AUGUSTUS_CONFIG_PATH}\nbusco_sif busco \$*" > busco && chmod +x busco
echo -e '#!/bin/bash\n'"busco_sif generate_plot.py \$*" > generate_plot.py && chmod +x generate_plot.py

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
whatis("URL: ".."https://busco.ezlab.org/")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."assembly")
whatis("Description: ".."Assessing genome assembly and annotation completeness with Benchmarking Universal Single-Copy Orthologs (BUSCO).")

-- Package settings
depends_on("singularity/3.5.2")
prepend_path("PATH", apphome)
__END__
