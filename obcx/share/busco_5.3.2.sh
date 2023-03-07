#!/bin/bash
module purge
set -eux

module load singularity

module use /work/00/gg57/share/yoshi-tools/.modulefiles
module load busco_downloads/5_2023.01.30

MODROOT=/work/00/gg57/share/yoshi-tools
APP=busco
VER=5.3.2

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR && cd $APPDIR

singularity pull busco.sif docker://ezlabgva/busco:v${VER}_cv1

# NOTE: Copying Augustus config dir to CWD because it can be overwritten by another BUSCO job
cat <<__END__ >busco_sif
#!/bin/bash
singularity exec $APPDIR/busco.sif \$*
__END__
cat <<__END__ >busco
#!/bin/bash
export SINGULARITYENV_AUGUSTUS_CONFIG_PATH=\$(pwd)/augustus_config
echo "\""Copying Augustus config dir to \${SINGULARITYENV_AUGUSTUS_CONFIG_PATH}"\""
rm -rf \${SINGULARITYENV_AUGUSTUS_CONFIG_PATH}
busco_sif cp -r /usr/local/config \${SINGULARITYENV_AUGUSTUS_CONFIG_PATH}
busco_sif busco --offline --download_path $BUSCO_DOWNLOADS \$*
__END__
cat <<__END__ >generate_plot.py
#!/bin/bash
busco_sif generate_plot.py \$*
__END__
chmod +x busco_sif busco generate_plot.py

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("singularity")
prepend_path("PATH", apphome)
setenv("SINGULARITY_BIND", "/work/00/gg57/g57015,/work/gg57/g57015,/work/00/gg57/share,/work/gg57/share")
__END__
