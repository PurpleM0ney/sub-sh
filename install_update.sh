#!/bin/bash

#color
GREEN="\033[0;32m"
DEFAULT="\033[0m"

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
        CUR_VER=${FILE_NAME//subspace-cli-ubuntu-x86_64-/}
        echo -e "${GREEN}/nVersion $CUR_VER successfully installed"
        echo -e "\033[0m"
      fi
   fi
fi
rm latest*
./sub/./$FILE_NAME farm
