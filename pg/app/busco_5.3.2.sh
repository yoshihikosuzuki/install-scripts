#!/bin/bash
module purge
set -eux

module use /nfs/data05/yoshihiko_s/app/.modulefiles
module load busco_downloads/5_2022.05.31

MODROOT=/nfs/data05/yoshihiko_s/app
APP=busco
VER=5.3.2

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
prepend_path("PATH", apphome)
setenv("SINGULARITY_BIND", "/data,/glusterfs,/glusterfs2,/glusterfs3,/grid2,/hpgdata,/hpgwork,/hpgwork2,/nfs/data05,/nfs/data06")
execute {
    cmd = "OS_VER=\$(cat /etc/redhat-release | grep -oP '[0-9]+' | head -1); if [ \"\${OS_VER}\" == '6' ]; then printf \"\\\\033[0;33m [WARN]\\\\033[0m \"; echo \"Module " .. appname .. "/" .. appversion .. " does not work on CentOS 6\"; fi",
    modeA = { "load" }
}
__END__
