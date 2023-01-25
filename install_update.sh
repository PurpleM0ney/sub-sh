#!/bin/bash

#------------------- Блок проверкой наличия data.txt ----------------------------

DATA=$(ls ~/SubSpace/ | grep data)

if [ -z $DATA ]; then
   touch data.txt
   mv data.txt ~/SubSpace/
      
   echo "-----------------------------------------------------------------------------"
   read -p "Name your node: " NODE_NAME
   sleep 1
   echo "NAME="$NODE_NAME >> ~/SubSpace/data.txt
      
   echo "-----------------------------------------------------------------------------"
   read -p "Enter wallet address: " YOUR_WALLET
   sleep 1
   echo "WALLET="$YOUR_WALLET >> ~/SubSpace/data.txt
   echo "-----------------------------------------------------------------------------"
   echo -e '\n\e[42mDone!\e[0m\n'
      
else
   source ~/SubSpace/data.txt
   echo $WALLET
fi

#------------------- Блок с проверкой установки ноды и ее установкой (если не найдена) ----------------------------

wget https://api.github.com/repos/subspace/subspace-cli/releases/latest
if [ -f ./latest ]; then
   LATEST_TAG=$(jq --raw-output '.tag_name' "./latest")
   DAEMON_VERSION=$(ls ~/subspace-sh/sub/)
   LATEST_TAG=subspace-cli-ubuntu-x86_64-$LATEST_TAG
   
   #Нода не устанолвена
   if [ -z $DAEMON_VERSION ]; then
   FILE_NAME=$LATEST_TAG
   curl -JL -o ./sub/$FILE_NAME $(jq --raw-output '.assets | map(select(.name | startswith("subspace-cli-ubuntu-x86_64"))) | .[0].browser_download_url' "./latest")
   chmod +x ./sub/$FILE_NAME
   
   #создаем screen Init
   screen -d -m -S subInit
   screen -r subInit -X stuff  "/root/subspace-sh/sub/./$FILE_NAME init^M"
   sleep 1
   screen -r subInit -X stuff  "$WALLET"
   sleep 1
   screen -r subInit -X stuff  "^M"
   sleep 1
   screen -r subInit -X stuff  "$NAME^M"
   sleep 1
   if [ -f ./latest ]; then
        screen -d -m -S subInit
        screen -r subInit -X stuff  "/root/subspace-sh/sub/./$FILE_NAME init^M"
        sleep 1
        screen -r subInit -X stuff  "$WALLET"
        sleep 1
        screen -r subInit -X stuff  "^M"
        sleep 1
        screen -r subInit -X stuff  "$NAME^M"
        sleep 1
        screen -r subInit -X stuff  "^M"
        sleep 1
        screen -r subInit -X stuff  "^M"
        sleep 1
        screen -r subInit -X stuff  "^M" 
        sleep 1
        screen -X -S subInit quit
        sleep 1
        
        #Создаем screen Farm
        screen -d -m -S subFarm
        sleep 1
        screen -r subFarm -X stuff  "/root/subspace-sh/sub/./$FILE_NAME farm^M"
        sleep 1
   
        echo "-----------------------------------------------------------------------------"
        echo -e "\n\e[42mThe node has been successfully updated! The current version is $CUR_VER\e[0m\n"
        echo "-----------------------------------------------------------------------------"
        rm latest*
      fi
   
   #------------------- Блок в случае, если установлена актуальная версия ----------------------------
  
  else
      rm latest*
      CUR_VER=${DAEMON_VERSION//subspace-cli-ubuntu-x86_64-/}
      echo -e "\n\e[42mYou have the current ($CUR_VER) version installed!\e[0m\n"
      echo -e "You can check the operation of farmer with the command: \n\e[31mscreen -r subFarm\e[0m\n"
      echo "-----------------------------------------------------------------------------"
   fi
fi
