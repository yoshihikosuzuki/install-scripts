#!/bin/bash
# NOTE: Run this script on **pg**
shopt -s expand_aliases
source $HOME/.bashrc
set -eux

W_DIR=$HOME/tmp
I_DIR=$HOME/.local

mkdir -p ${W_DIR} ${I_DIR}
cd ${W_DIR}

tar zxvf rust-1.60.0-x86_64-unknown-linux-gnu.tar.gz
cd rust-1.60.0-x86_64-unknown-linux-gnu
./install.sh --prefix=${I_DIR}
