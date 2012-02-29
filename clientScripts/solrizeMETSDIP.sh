#!/bin/bash
# solrizeMETSDIP.sh

set -e

DIP=$1
SCRIPTS=$2

STORAGEHOST=storagerep.uky.edu
SOLRHOST=blacklightrep.uky.edu
USER=rails

JSONDIR=/home/$USER/json/incoming
APPDIR=/home/$USER/apps/presence-blacklight/current

IDENTIFIER=`basename $DIP`
ERCFILE=$DIP/data/metadata/erc.txt
URL=http://$STORAGEHOST/dips/$IDENTIFIER/data/METS.xml
JSON=$DIP/$IDENTIFIER.json

ruby $SCRIPTS/summarize_erc.rb $URL $ERCFILE $IDENTIFIER > $JSON
rsync -avPO -e ssh $JSON $USER@$SOLRHOST:$JSONDIR
rsync -avPO -e ssh $JSON $USER@$SOLRHOST:$JSONDIR
ssh $USER@$SOLRHOST "index-into $APPDIR $JSONDIR/$IDENTIFIER.json"
#rm $JSON
