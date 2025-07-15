#!/bin/bash
module purge
set -eux

module use /nfs/data05/yoshihiko_s/app/.modulefiles
module load R/4.3.1 python/3.10.14

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data05/yoshihiko_s/app
APP=fithichip
VER=11.0

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
git clone https://github.com/ay-lab/FitHiChIP
mv FitHiChIP $VER
cd $VER
chmod +x *.sh
# NOTE: Edit `FitHiChIP_HiCPro.sh` around `HiCProBasedir`

PYTHONUSERBASE=$APPDIR/$VER pip install --force-reinstall --user networkx numpy hic-straw cooler
mkdir -p lib/R
export R_LIBS=$APPDIR/$VER/lib/R
Rscript -e 'install.packages(c("optparse", "ggplot2", "data.table", "splines", "fdrtool", "parallel", "tools", "plyr", "dplyr"), lib="./lib/R")'
Rscript -e 'if (!requireNamespace("BiocManager", quietly=TRUE)) install.packages("BiocManager", lib="./lib/R"); options(repos=BiocManager::repositories()); BiocManager::install(c("GenomicRanges", "edgeR"), lib="./lib/R")'

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("samtools/1.18", "htslib/1.15.1", "bedtools/2.30.0", "ucsc_tools/2024.09.13", "bowtie2/2.2.6", "hicpro/3.0.0", "macs2/2.2.7.1", "R/4.3.1", "python/3.10.14")
prepend_path("PYTHONPATH", pathJoin(apphome, "lib/python3.10/site-packages"))
prepend_path("R_LIBS", pathJoin(apphome, "lib/R"))
prepend_path("PATH", apphome)
__END__
