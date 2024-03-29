#!/bin/bash
module purge
set -eux

module use /nfs/data05/yoshihiko_s/app/.modulefiles
module load busco_downloads/5_2022.05.31

MODROOT=/nfs/data05/yoshihiko_s/app
APP=busco
VER=5.1.3

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR && cd $APPDIR

singularity pull busco.sif docker://ezlabgva/busco:v${VER}_cv1

# NOTE: Copying Augustus config dir to CWD because it can be overwritten by another BUSCO job
cat <<__END__ >busco_sif
#!/bin/bash
singularity exec -B \$(pwd):/busco_wd/ $APPDIR/busco.sif \$*
__END__
cat <<__END__ >busco
#!/bin/bash
export SINGULARITYENV_AUGUSTUS_CONFIG_PATH=\$(pwd)/augustus_config
echo "\""Copying Augustus config dir to \${SINGULARITYENV_AUGUSTUS_CONFIG_PATH}"\""
rm -rf \${SINGULARITYENV_AUGUSTUS_CONFIG_PATH}
busco_sif cp -r /augustus/config \${SINGULARITYENV_AUGUSTUS_CONFIG_PATH}
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
prepend_path("PATH", apphome)
setenv("SINGULARITY_BIND", "/bio,/data,/glusterfs,/glusterfs2,/glusterfs3,/grid2,/home,/hpgdata,/hpgwork,/hpgwork2")
__END__
