#!/bin/bash

#color
GREEN="\033[0;32m"
DEFAULT="\033[0m"

#wget https://api.github.com/repos/subspace/subspace-cli/releases
if [ -f ./releases ]; then
   LATEST_TAG=$(curl https://api.github.com/repos/subspace/subspace/releases | jq --raw-output '[.[] | select(.prerelease==true) | select(.tag_name | startswith("runtime") | not) | select(.tag_name | startswith("chain-spec") | not)][0].tag_name')
   echo $LATEST_TAG
   
   #Получаем какие версии у нас на ноде
   VERSION_NODE=$(ls ~/subspace-sh/sub/ | grep node)
   VERSION_FARMER=$(ls ~/subspace-sh/sub/ | grep farmer)

   #Получаем версию, которая должна быть
   LATEST_NODE=subspace-farmer-ubuntu-x86_64-$LATEST_TAG
   LATEST_FARMER=subspace-cli-ubuntu-x86_64-$LATEST_TAG
   
   if [ -z $VERSION_NODE ]; then 
   wget -P ~/subspace-sh/sub https://github.com/subspace/subspace/releases/download/$LATEST_TAG/subspace-node-ubuntu-x86_64-$LATEST_TAG
   fi
   
   if [ -z $VERSION_FARMER ]; then 
   wget -P ~/subspace-sh/sub https://github.com/subspace/subspace/releases/download/$LATEST_TAG/subspace-farmer-ubuntu-x86_64-$LATEST_TAG
   fi
   
   echo "Установлен Фармер - $VERSION_FARMER"
   echo "Установлена нода - $VERSION_NODE"
   echo "Сейчас автуален фармер - $LATEST_FARMER"
   echo "Сейчас актуальна нода - $LATEST_NODE"
fi
