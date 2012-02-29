#!/bin/bash
set -e

WORKING_PATH=$1
CLIENT_SCRIPTS_DIRECTORY=$2
NEXT_MICROSERVICE=$3

# Incoming parameters:
# $1 relative location (working path)
# $2 path to client scripts directory
# $3 path to Solrize watch directory

# Get the path of the zip file we're dealing with, 
# and of the bag we're about to extract.
# e.g. if the incoming path is /foo/bar/baz, the package is baz.
PACKAGE=`basename $WORKING_PATH`
ZIPNAME=$WORKING_PATH/$PACKAGE.zip
BAGNAME=$WORKING_PATH/$PACKAGE

# Unzip the zip file, pass the extracted bag to createMETSDIP.rb,
# and move the created METS DIP into the Solrize watch dir.
unzip $ZIPNAME -d $WORKING_PATH
ruby $CLIENT_SCRIPTS_DIRECTORY/createMETSDIP.rb $BAGNAME
mv $BAGNAME $NEXT_MICROSERVICE
