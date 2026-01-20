#!/bin/bash
module purge
set -eu
module load R/4.3.1
set -x

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data05/yoshihiko_s/app
APP=easystrata
VER=2.0.0

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh -b -p $APPDIR/$VER
cd $VER
git clone https://github.com/QuentinRougemont/EASYstrata
./bin/mamba env create -y -f EASYstrata/INSTALL/annotation_env.yml   
./bin/mamba env create -y -f EASYstrata/INSTALL/busco_env.yml
./bin/mamba env create -y -f EASYstrata/INSTALL/repeatmodeler.yml
## NOTE:
# To activate the environments, use:
#     mamba activate superannot

mkdir -p lib/R
export R_LIBS=./lib/R
Rscript -e 'install.packages(c("devtools"), lib="./lib/R")'
Rscript -e 'devtools::install_github("jtlovell/GENESPACE", lib="./lib/R")'

eval "$(mamba shell hook --shell bash)"
./EASYstrata/INSTALL/dependencies.sh

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("R/4.3.1")
prepend_path("PATH", pathJoin(apphome, "bin"))
prepend_path("R_LIBS", pathJoin(apphome, "lib/R"))
if (mode() == "load") then
    execute{
        cmd  = "source $MODROOT/$APP/$VER/softs/paths.sh",
        modeA = {"load"}
    }
end
__END__
