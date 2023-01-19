#!/bin/bash

#color
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
PURPLE="\033[0;35m"
RED='\033[0;31m'
GREEN="\033[0;32m"
NC='\033[0m'
MAG='\e[1;35m'

wget https://api.github.com/repos/subspace/subspace-cli/releases/latest
if [ -f ./latest ]; then
   LATEST_TAG=$(jq --raw-output '.tag_name' "./latest")
   DAEMON_VERSION=$(ls ~/subspace-sh/sub/)
   LATEST_TAG=subspace-cli-ubuntu-x86_64-$LATEST_TAG
   if [ -z $DAEMON_VERSION ]; then DAEMON_VERSION="new"; fi
   if [ $DAEMON_VERSION != $LATEST_TAG ]; then
     FILE_NAME=$LATEST_TAG
     curl -JL -o ./sub/$FILE_NAME $(jq --raw-output '.assets | map(select(.name | startswith("subspace-cli-ubuntu-x86_64"))) | .[0].browser_download_url' "./latest")
     rm ./sub/$DAEMON_VERSION
      if [ -f ./sub/$FILE_NAME ]; then
        chmod +x ./sub/$FILE_NAME
        echo -n -e "${PURPLE}Version $FILE_NAME successfully installed, start the farmer"
        ./sub/./$FILE_NAME farm
      fi
   fi
fi
rm latest*
