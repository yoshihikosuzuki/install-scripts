#!/bin/bash
module purge
set -eux

MODROOT=/nfs/data05/yoshihiko_s/app
APP=3d-dna
VER=180922

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

git clone https://github.com/aidenlab/3d-dna
mv 3d-dna $VER
cd $VER
ln -sf run-asm-pipeline.sh 3d-dna
ln -sf run-asm-pipeline-post-review.sh 3d-dna-post-review
cd visualize/
ln -sf run-assembly-visualizer.sh 3d-dna-run-assembly-visualizer
cd ..
cat <<__END__ >3d-dna-fasta2assembly
#!/bin/sh
awk -f $APPDIR/$VER/utils/generate-assembly-file-from-fasta.awk \$*
__END__
chmod +x *.sh */*.sh 3d-dna-fasta2assembly

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("juicer/1.6", "parallel", "bioawk", "bwa")
prepend_path("PATH", apphome)
prepend_path("PATH", pathJoin(apphome, "visualize"))
__END__
