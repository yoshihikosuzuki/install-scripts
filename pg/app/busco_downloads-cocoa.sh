#!/bin/bash

D_DIR=$HOME/pg_transit

# NOTE: Make sure $APPDIR exists on pg
MODROOT=/nfs/data05/yoshihiko_s/app
APP=busco_downloads
VER=5_2022.05.31
APPDIR=$MODROOT/$APP/$VER

mkdir -p ${D_DIR}
cd ${D_DIR}

wget -r https://busco-data.ezlab.org/v5/data/lineages/
scp -r busco-data.ezlab.org/v5/data/* pg:${APPDIR}/
