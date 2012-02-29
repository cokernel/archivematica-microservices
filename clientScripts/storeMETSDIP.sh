#!/bin/bash
# storeMETSDIP.sh

set -e

HOST=storagerep.uky.edu
DIRNAME=`dirname $1`
IDENTIFIER=`basename $1`
DIP="$DIRNAME/$IDENTIFIER"
STORAGE=/storage
INCOMING=$STORAGE/incoming
PAIRTREE=$STORAGE/dips

rsync -avPO -e ssh $DIP archivematica@$HOST:$INCOMING
rsync -avPO -e ssh $DIP archivematica@$HOST:$INCOMING
ssh archivematica@$HOST "pt_pack.sh $PAIRTREE $INCOMING/$IDENTIFIER"
ssh archivematica@$HOST "/bin/rm -rf $INCOMING/$IDENTIFIER"
echo "end of storeMETSDIP.sh"
exit 0

