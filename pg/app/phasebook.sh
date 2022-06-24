#!/bin/bash
module purge
set -eu
module use /bio/package/.modulefiles
module load gcc/9.2.0
set -x

MODROOT=/hpgwork2/yoshihiko_s/app
APP=phasebook
VER=1.0.0

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

CONDA_SH=Miniconda3-py37_4.9.2-Linux-x86_64.sh
curl -O https://repo.anaconda.com/miniconda/${CONDA_SH}
sh ${CONDA_SH} -b -p $APPDIR/$VER
rm ${CONDA_SH}
cd $VER
./bin/conda install -y -c bioconda whatshap=0.18 minimap2=2.18 longshot=0.4.1 samtools=1.12 bcftools=1.12 racon=1.4.20 fpa=0.5
./bin/conda install -y -c conda-forge boost zlib
# TODO: still need this?
export LD_LIBRARY_PATH=$(readlink -f ./lib):$LD_LIBRARY_PATH
# TODO: replace with -I../../../include in sed below?
export CPATH=$(readlink -f ./include):$CPATH
rm -rf pkgs
wget -O - https://github.com/phasebook/phasebook/archive/refs/tags/v1.0.0.tar.gz | tar xzvf -
cd phasebook
sed -i "s|LIBS = -l boost_timer -l boost_system -l boost_program_options|LIBS = -l boost_timer -l boost_system -l boost_program_options -L../../../lib -Wl,-rpath=../../../lib|" tools/HaploConduct/makefile
sh install.sh
cat <<__END__ >bin/phasebook
#!/bin/sh
python $APPDIR/$VER/phasebook-$VER/scripts/phasebook.py \$*
__END__
chmod +x bin/phasebook

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", pathJoin(apphome, "bin"))
prepend_path("PATH", pathJoin(apphome, "phasebook-$VER/bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(apphome, "lib"))
__END__
