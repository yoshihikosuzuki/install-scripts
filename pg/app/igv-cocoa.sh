#!/bin/bash
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

D_DIR=$HOME/pg_transit
PG_DIR=$HOME/tmp

mkdir -p ${D_DIR}
cd ${D_DIR}

APP=igv
VER=2.11.9

wget https://data.broadinstitute.org/igv/projects/downloads/2.11/IGV_$VER.zip
scp IGV_$VER.zip pg:${PG_DIR}
