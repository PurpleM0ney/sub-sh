#!/bin/bash

FILE_NAME="subspace"

wget https://api.github.com/repos/idena-network/idena-go/releases/latest
if [ -f ./latest ]; then
   LATEST_TAG=$(jq --raw-output '.tag_name' "./latest")
   LATEST_TAG=${LATEST_TAG//v/}
   DAEMON_VERSION=$(/root/idena/idena-go -v | awk '{print $3}')
   if [ -z $DAEMON_VERSION ]; then DAEMON_VERSION="new"; fi
   if [ $DAEMON_VERSION != $LATEST_TAG ]; then
      curl -JL -o ./$FILE_NAME $(jq --raw-output '.assets | map(select(.name | startswith("idena-node-linux"))) | .[0].browser_download_url' "./latest")
      if [ -f $FILE_NAME ]; then
         chmod +x $FILE_NAME
         pKILL=$(pwdx $(ps -e | grep idena | awk '{print $1 }') | grep /root)
         pKILL=$(echo $pKILL | awk '{print $1}' | sed s/.$//)
         if [ ! -z pKILL ]; then systemctl stop idena.service; fi
         mv $FILE_NAME /root/idena/idena-go
         systemctl start idena.service
      fi
   fi
fi
rm latest*
