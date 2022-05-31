#!/bin/bash

D_DIR=$HOME/pg_transit
PG_DIR=$HOME/tmp

mkdir -p ${D_DIR}
cd ${D_DIR}

rm -r busco
mkdir busco
cd busco
wget https://busco-data.ezlab.org/v5/data/file_versions.tsv
wget -r https://busco-data.ezlab.org/v5/data/lineages/
cd ..
scp -r busco pg:${PG_DIR}
