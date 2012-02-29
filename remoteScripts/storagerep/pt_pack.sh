#!/bin/bash
# pt_pack.sh

source $HOME/.bashrc
rvm use 1.9.2
ruby $HOME/bin/pt_pack $@
