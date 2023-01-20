#!/bin/bash

#color
GREEN="\033[0;32m"
DEFAULT="\033[0m"

bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
   LATEST_TAG=$(curl https://api.github.com/repos/subspace/subspace/releases | jq --raw-output '[.[] | select(.prerelease==true) | select(.tag_name | startswith("runtime") | not) | select(.tag_name | startswith("chain-spec") | not)][0].tag_name')
   echo $LATEST_TAG
   mkdir /root/subspace
   
   #Получаем какие версии у нас на ноде
   VERSION_NODE=$(ls ~/root/subspace/ | grep node)
   VERSION_FARMER=$(ls ~/root/subspace/ | grep farmer)

   #Получаем версию, которая должна быть
   LATEST_NODE=subspace-farmer-ubuntu-x86_64-$LATEST_TAG
   LATEST_FARMER=subspace-cli-ubuntu-x86_64-$LATEST_TAG
   
   if [ -z $VERSION_NODE ]; then 
   cd $HOME
   wget  https://github.com/subspace/subspace/releases/download/$LATEST_TAG/subspace-node-ubuntu-x86_64-$LATEST_TAG
   chmod +x subspace*
   mv subspace* /root/subspace/

   source ~/.bash_profile
sleep 1
   fi
   
   if [ -z $VERSION_FARMER ]; then 
   cd $HOME
   wget https://github.com/subspace/subspace/releases/download/$LATEST_TAG/subspace-farmer-ubuntu-x86_64-$LATEST_TAG
   chmod +x subspace*
   mv subspace* /root/subspace/

   source ~/.bash_profile
 sleep 1
   fi
   
   #Отладка
   VERSION_NODE=$(ls ~/root/subspace/ | grep node)
   VERSION_FARMER=$(ls ~/root/subspace/ | grep farmer)
   echo "Установлен Фармер - $VERSION_FARMER"
   echo "Установлена нода - $VERSION_NODE"
   echo "Сейчас автуален фармер - $LATEST_FARMER"
   echo "Сейчас актуальна нода - $LATEST_NODE"
fi
