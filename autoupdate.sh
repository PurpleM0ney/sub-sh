#!/bin/bash
PURPLE="\033[0;35m"

wget https://api.github.com/repos/subspace/subspace-cli/releases/latest
if [ -f ./latest ]; then
   LATEST_TAG=$(jq --raw-output '.tag_name' "./latest")
   #LATEST_TAG=${LATEST_TAG//v/}
   DAEMON_VERSION=$(ls ~/subspace-sh/sub/)
   LATEST_TAG=subspace-cli-ubuntu-x86_64-$LATEST_TAG
   if [ -z $DAEMON_VERSION ]; then DAEMON_VERSION="new"; fi
   if [ $DAEMON_VERSION != $LATEST_TAG ]; then
     FILE_NAME=subspace-cli-ubuntu-x86_64-$LATEST_TAG
     curl -JL -o ./sub/$FILE_NAME $(jq --raw-output '.assets | map(select(.name | startswith("subspace-cli-ubuntu-x86_64"))) | .[0].browser_download_url' "./latest")
      #if [ -f $FILE_NAME ]; then
        # chmod +x $FILE_NAME
        # pKILL=$(pwdx $(ps -e | grep idena | awk '{print $1 }') | grep /root)
         #pKILL=$(echo $pKILL | awk '{print $1}' | sed s/.$//)
         #if [ ! -z pKILL ]; then systemctl stop idena.service; fi
         #mv $FILE_NAME /root/idena/idena-go
         #systemctl start idena.service
      #fi
   fi
fi
