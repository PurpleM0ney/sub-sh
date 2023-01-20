#!/bin/bash

DATA_NAME="data.txt"
DATA_PATH="subspace-scripts"

#color
GREEN="\033[0;32m"
DEFAULT="\033[0m"

wget https://api.github.com/repos/subspace/subspace-cli/releases/latest
if [ -f ./latest ]; then
   LATEST_TAG=$(jq --raw-output '.tag_name' "./latest")
   DAEMON_VERSION=$(ls ~/subspace-sh/sub/)
   LATEST_TAG=subspace-cli-ubuntu-x86_64-$LATEST_TAG
   
   if [ -z $DAEMON_VERSION ]; then #Ищем версию
   	FIND_DATA=$(find . -name "data.txt*")
	
  	if [ -z $FIND_DATA ]; then #Ищем файл data.txt
	   read -p "Enter your farmer/reward address: " ADDRESS
	   echo 'ADDRESS='$ADDRESS >> data.txt
  	   sleep 1
  	   echo "-----------------------------------------------------------------------------"
	  echo -e '\n\e[42mГотово\e[0m\n'
   	fi

   #Узнаем адрес ноды и записываем в CHCK_ADDRESS
   CHCK_ADDRESS=$(head data.txt | grep ADDRESS)
   CHCK_ADDRESS=${CHCK_ADDRESS//ADDRESS=/}
   echo "Ваш кошелек $CHCK_ADDRESS"

   FILE_NAME=$LATEST_TAG
   curl -JL -o ./sub/$FILE_NAME $(jq --raw-output '.assets | map(select(.name | startswith("subspace-cli-ubuntu-x86_64"))) | .[0].browser_download_url' "./latest")
   chmod +x ./sub/$FILE_NAME
   rm latest*
   #./sub/./$FILE_NAME init
   sleep 1
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
