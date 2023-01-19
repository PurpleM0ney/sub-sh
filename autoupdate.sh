#!/bin/bash
PURPLE="\033[0;35m"

wget https://api.github.com/repos/subspace/subspace-cli/releases/latest
if [ -f ./latest ]; then
   LATEST_TAG=$(jq --raw-output '.tag_name' "./latest")
   #LATEST_TAG=${LATEST_TAG//v/}
   DAEMON_VERSION=$(ls ~/subspace-sh/sub/)
   echo $DAEMON_VERSION
   LATEST_TAG=subspace-cli-ubuntu-x86_64-$LATEST_TAG
   if [ -z $DAEMON_VERSION ]; then DAEMON_VERSION="new"; fi
   if [ $DAEMON_VERSION != $LATEST_TAG ]; then
     FILE_NAME=$LATEST_TAG
     curl -JL -o ./$FILE_NAME $(jq --raw-output '.assets | map(select(.name | startswith("subspace-cli-ubuntu-x86_64"))) | .[0].browser_download_url' "./latest")
     rm latest*
     cd sub
     rm $DAEMON_VERSION
      if [ -f $FILE_NAME ]; then
        chmod +x $FILE_NAME
        ./$FILE_NAME farm
      fi
   fi
fi
