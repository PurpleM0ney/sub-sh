#!/bin/bash

#color
GREEN="\033[0;32m"
DEFAULT="\033[0m"

wget https://api.github.com/repos/subspace/subspace-cli/releases/latest
if [ -f ./latest ]; then
   LATEST_TAG=$(jq --raw-output '.tag_name' "./latest")
   DAEMON_VERSION=$(ls ~/subspace-sh/sub/)
   LATEST_TAG=subspace-cli-ubuntu-x86_64-$LATEST_TAG
   
   if [ -z $DAEMON_VERSION ]; then
   FILE_NAME=$LATEST_TAG
   curl -JL -o ./sub/$FILE_NAME $(jq --raw-output '.assets | map(select(.name | startswith("subspace-cli-ubuntu-x86_64"))) | .[0].browser_download_url' "./latest")
   chmod +x ./sub/$FILE_NAME
   rm latest*
   
   #создаем screen
   screen -d -m -S subInit
   screen -r subInit -X stuff  "/root/sub-sh/sub/./$FILE_NAME init^M"
   sleep 2
   screen -r subInit -X stuff  "stBXULMGfc44YKaFRm2VGuczonxq5a2yTqfseQBB49o77bgwR^M"
   sleep 2
   screen -r subInit -X stuff  "PurpleMoney^M"
   sleep 2
   screen -r subInit -X stuff  "^M"
   sleep 2
   screen -r subInit -X stuff  "^M"
   sleep 2
   screen -r subInit -X stuff  "^M" 
   sleep 2
   screen -X -S subInit quit
   sleep 2
   
   CUR_VER=${FILE_NAME//subspace-cli-ubuntu-x86_64-/}
   echo "-----------------------------------------------------------------------------"
   echo -e "\n\e[42mThe node has been successfully installed! The current version is $CUR_VER. Starting a farmer!\e[0m\n"
   echo "-----------------------------------------------------------------------------"
   ./sub/./$FILE_NAME farm 
   fi
   if [[ $DAEMON_VERSION != $LATEST_TAG ]]; then
     FILE_NAME=$LATEST_TAG
     curl -JL -o ./sub/$FILE_NAME $(jq --raw-output '.assets | map(select(.name | startswith("subspace-cli-ubuntu-x86_64"))) | .[0].browser_download_url' "./latest")
     rm ./sub/$DAEMON_VERSION
      if [ -f ./sub/$FILE_NAME ]; then
        chmod +x ./sub/$FILE_NAME
        CUR_VER=${FILE_NAME//subspace-cli-ubuntu-x86_64-/}
        echo "-----------------------------------------------------------------------------"
        echo -e "\n\e[42mThe node has been successfully updated! The current version is $CUR_VER\e[0m\n"
        echo "-----------------------------------------------------------------------------"
        rm latest*
        ./sub/./$FILE_NAME farm
      fi
   
   else
      rm latest*
      CUR_VER=${DAEMON_VERSION//subspace-cli-ubuntu-x86_64-/}
      echo "-----------------------------------------------------------------------------"
      echo -e "\n\e[42mChecked, you have the current ($CUR_VER) version installed!\e[0m\n"
      echo "-----------------------------------------------------------------------------"
      ./sub/./$DAEMON_VERSION farm
   fi
fi
