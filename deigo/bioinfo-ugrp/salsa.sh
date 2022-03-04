#!/bin/bash

ml python/2.7.18

APP=SALSA
VER=2.3
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

wget -O - https://github.com/marbl/SALSA/archive/refs/tags/v$VER.tar.gz | tar xzvf -
mv $APP-$VER $VER && cd $VER && make
mkdir -p lib/python2.7/site-packages
PYTHONUSERBASE=$(pwd) pip install numpy scipy networkx --force-reinstall --user
wget https://s3.amazonaws.com/hicfiles.tc4ga.com/public/juicer/juicer_tools_1.22.01.jar
cat <<'__END__' > convert.sh
#!/bin/bash
JUICER_JAR=/apps/unit/BioinfoUgrp/Other/SALSA/2.3/juicer_tools_1.22.01.jar
SALSA_OUT_DIR=$1

samtools faidx ${SALSA_OUT_DIR}/scaffolds_FINAL.fasta
cut -f 1,2 ${SALSA_OUT_DIR}/scaffolds_FINAL.fasta.fai > ${SALSA_OUT_DIR}/chromosome_sizes.tsv
alignments2txt.py -b ${SALSA_OUT_DIR}/alignment_iteration_1.bed -a ${SALSA_OUT_DIR}/scaffolds_FINAL.agp -l ${SALSA_OUT_DIR}/scaffold_length_iteration_1 > ${SALSA_OUT_DIR}/alignments.txt
awk '{if ($2 > $6) {print $1"\t"$6"\t"$7"\t"$8"\t"$5"\t"$2"\t"$3"\t"$4} else {print}}'  ${SALSA_OUT_DIR}/alignments.txt | sort -k2,2d -k6,6d -T $PWD --parallel=16 | awk 'NF'  > ${SALSA_OUT_DIR}/alignments_sorted.txt
java -jar -Xmx500G ${JUICER_JAR} pre ${SALSA_OUT_DIR}/alignments_sorted.txt ${SALSA_OUT_DIR}/salsa_scaffolds.hic ${SALSA_OUT_DIR}/chromosome_sizes.tsv
__END__

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
whatis("URL: ".."https://github.com/marbl/SALSA")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."assembly, scaffolding")
whatis("Description: ".."SALSA: A tool to scaffold long read assemblies with Hi-C data.")

-- Package settings
depends_on("python/2.7.18", "bedtools")
prepend_path("PATH", apphome)
prepend_path("PYTHONPATH", apphome.."/lib/python2.7/site-packages")
__END__
