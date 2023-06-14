#!/bin/bash
set -eux

D_DIR=$HOME/pg_transit
PG_DIR=$HOME

mkdir -p ${D_DIR}
cd ${D_DIR}

wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
scp awscli-exe-linux-x86_64.zip pg:${PG_DIR}
