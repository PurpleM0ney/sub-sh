#!/bin/bash

#names
SCRIPT_NAME="autoupdate.sh"
SCRIPT_PATH="subspace-scripts"

#color
GREEN="\033[0;32m"
DEFAULT="\033[0m"

if [[ "$USER" == "root" ]]; then
        HOMEFOLDER="/root"
else
        HOMEFOLDER="/home/$USER"
fi

CURRENTDIR=$(pwd)
if [ ! -d $HOMEFOLDER/$SCRIPT_PATH ]; then mkdir $HOMEFOLDER/$SCRIPT_PATH; fi
cd $HOMEFOLDER/$SCRIPT_PATH

echo "Start install autoupdate scripts"
#Доделай

wget https://api.github.com/repos/subspace/subspace-cli/releases/latest
if [ -f ./latest ]; then
   LATEST_TAG=$(jq --raw-output '.tag_name' "./latest")
   DAEMON_VERSION=$(ls ~/subspace-sh/sub/)
   LATEST_TAG=subspace-cli-ubuntu-x86_64-$LATEST_TAG
   if [ -z $DAEMON_VERSION ]; then DAEMON_VERSION="new"; fi
   if [ $DAEMON_VERSION != $LATEST_TAG ]; then
     FILE_NAME=$LATEST_TAG
     curl -JL -o ./sub/$FILE_NAME $(jq --raw-output '.assets | map(select(.name | startswith("subspace-cli-ubuntu-x86_64"))) | .[0].browser_download_url' "./latest")
      if [ $DAEMON_VERSION != "new" ]; then rm ./sub/$DAEMON_VERSION; fi
      if [ -f ./sub/$FILE_NAME ]; then
        chmod +x ./sub/$FILE_NAME
        echo ""
        CUR_VER=$FILE_NAME
        CUR_VER=${CUR_VER//subspace-cli-ubuntu-x86_64-v/}
        echo -e "${GREEN}Version $CUR_VER successfully installed"
        echo -e "\033[0m"
      fi
   fi
fi

rm latest*
if [ -z $FILE_NAME ]; then 
        ~/subspace-sh/sub/./$DAEMON_VERSION farm
else
        ~/subspace-sh/sub/./$FILE_NAM farm
fi
