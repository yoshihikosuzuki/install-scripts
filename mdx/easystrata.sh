#!/bin/bash
module purge
set -ex

MODROOT=/large/yoshihiko_s/app
APP=easystrata
VER=2.0.0

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
# bash Miniforge3-$(uname)-$(uname -m).sh -b -p $APPDIR/$VER

cd $VER

# git clone https://github.com/QuentinRougemont/EASYstrata
# ## NOTE: `mamba activate superannot` to activate
# ./bin/mamba env create -y -f EASYstrata/INSTALL/annotation_env.yml
# ## NOTE: `mamba activate busco582` to activate
# ./bin/mamba env create -y -f EASYstrata/INSTALL/busco_env.yml
# ## NOTE: `mamba activate repeatmodeler_env` to activate
# ./bin/mamba env create -y -f EASYstrata/INSTALL/repeatmodeler.yml
# rm -rf pkgs

# ./bin/mamba install -c conda-forge -c defaults -y r-base=4.4.1
export PATH=$APPDIR/$VER/bin:$PATH

mkdir -p lib/R
export R_LIBS=./lib/R
# Rscript -e 'install.packages(c("devtools"), lib="./lib/R")'
# Rscript -e 'BiocManager::install("Biostrings", ask=FALSE, update=FALSE)'
# Rscript -e 'devtools::install_github("jtlovell/GENESPACE", lib="./lib/R")'

cd EASYstrata
# sed -i 's|~/.bashrc|$APPDIR/$VER/EASYstrata/path.sh|g' ./INSTALL/dependencies.sh
# sed 's|sed -i  "${n}s#usr/lib/x86_64-linux-gnu#$htpath/lib#g" common.mk|sed -i  "${n}s#usr/lib/x86_64-linux-gnu#$htpath/../../lib#g" common.mk|' ./INSTALL/dependencies.sh
# eval "$(mamba shell hook --shell bash)"
# mamba activate superannot
# Rscript -e 'remotes::install_version("ggplot2", version="3.5.1", lib="./lib/R")'
# source ./path.sh || true
# source ./INSTALL/dependencies.sh
cd ..

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", pathJoin(apphome, "bin"))
prepend_path("R_LIBS", pathJoin(apphome, "lib/R"))
prepend_path("MAMBA_ROOT_PREFIX", apphome)
if (mode() == "load") then
    execute{
        cmd  = "source $MODROOT/$APP/$VER/EASYstrata/path.sh; eval \"\$(mamba shell hook --shell bash)\"; echo 'To activate each environment: mamba activate {superannot,busco582,repeatmodeler_env}'",
        modeA = {"load"}
    }
end
__END__
