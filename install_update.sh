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
fi

#------------------- Блок с проверкой установки ноды и ее установкой (если не найдена) ----------------------------

wget -P ~/SubSpace/ https://api.github.com/repos/subspace/subspace-cli/releases/latest
if [ -f ./latest ]; then
   LATEST_TAG=$(jq --raw-output '.tag_name' "./latest")
   echo "TAGGG $LATEST_TAG"
   DAEMON_VERSION=$(ls ~/SubSpace/)
   LATEST_TAG=subspace-cli-ubuntu-x86_64-$LATEST_TAG
   
   #Нода не устанолвена
   if [ -z $DAEMON_VERSION ]; then
   FILE_NAME=$LATEST_TAG
   curl -JL -o ~/SubSpace/$FILE_NAME $(jq --raw-output '.assets | map(select(.name | startswith("subspace-cli-ubuntu-x86_64"))) | .[0].browser_download_url' "./latest")
   chmod +x ~/SubSpace/$FILE_NAME
   
   #создаем screen Init
   screen -d -m -S subInit
   screen -r subInit -X stuff  "~/SubSpace/./$FILE_NAME init^M"
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
   screen -r subFarm -X stuff  "/SubSpace/./$FILE_NAME farm^M"
   sleep 1
   
   DAEMON_VERSION=$(ls ~/SubSpace/)
   CUR_VER=${FILE_NAME//subspace-cli-ubuntu-x86_64-/}
   echo "-----------------------------------------------------------------------------"
   echo -e "\n\e[42mThe node has been successfully installed! The current version is $CUR_VER. Starting a farmer!\e[0m\n"
   echo "-----------------------------------------------------------------------------"
   rm latest*
   fi
   
#------------------- Блок с проверкой на наличие новых версий и последующим обновлением ----------------------------

   if [[ $DAEMON_VERSION != $LATEST_TAG ]]; then
    
     FILE_NAME=$LATEST_TAG
     screen -X -S subFarm quit
      
     #Получаем описание обновления
     BODY=$(jq '.body' "./latest")
     BODY=${BODY//before starting*/}
     BODY=${BODY//*you should/}
     
   if [[ ! -z $BODY ]]; then
     sleep 1
     #./sub/./$DAEMON_VERSION wipe
     echo "-----------------------------------------------------------------------------"
     echo -e "\n\e[42mWipe successful!\e[0m\n"
     echo "-----------------------------------------------------------------------------" 
   fi
     
     #Выполняем обновление
     curl -JL -o ~/SubSpace/$FILE_NAME $(jq --raw-output '.assets | map(select(.name | startswith("subspace-cli-ubuntu-x86_64"))) | .[0].browser_download_url' "./latest")
     rm ~/SubSpace/$DAEMON_VERSION
      if [ -f $FILE_NAME ]; then
        chmod +x ~/SubSpace/$FILE_NAME
        CUR_VER=${FILE_NAME//subspace-cli-ubuntu-x86_64-/}
        
        #создаем screen для Init
        screen -d -m -S subInit
        screen -r subInit -X stuff  "~/SubSpace/./$FILE_NAME init^M"
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
        screen -r subFarm -X stuff  "~/SubSpace/./$FILE_NAME farm^M"
        sleep 1
   
        echo "-----------------------------------------------------------------------------"
        echo -e "\n\e[42mThe node has been successfully updated! The current version is $CUR_VER\e[0m\n"
        echo "-----------------------------------------------------------------------------"
        rm latest*
      fi
   
   #------------------- Блок в случае, если установлена актуальная версия ----------------------------
  
  else
      CUR_VER=${DAEMON_VERSION//subspace-cli-ubuntu-x86_64-/}
      echo -e "\n\e[42mYou have the current ($CUR_VER) version installed!\e[0m\n"
      echo -e "You can check the operation of farmer with the command: \n\e[31mscreen -r subFarm\e[0m\n"
      echo "-----------------------------------------------------------------------------"
      rm latest*
   fi
fi
