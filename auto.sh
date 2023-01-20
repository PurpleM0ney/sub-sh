#!/bin/bash

if [ ! $NODE_NAME ]; then
	read -p "Дайте имя вашей ноде: " NODE_NAME
fi
sleep 1
echo 'export SUBSPACE_NODENAME='$NODE_NAME >> $HOME/.bash_profile
echo -e '\n\e[42mГотово\e[0m\n'
echo "-----------------------------------------------------------------------------"
if [ ! $YOUR_WALLET ]; then
	read -p "Введите адрес кошелька : " YOUR_WALLET
fi
sleep 1
echo 'export SUBSPACE_WALLET='$YOUR_WALLET >> $HOME/.bash_profile
echo -e '\n\e[42mГотово\e[0m\n'
echo "-----------------------------------------------------------------------------"

bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
   LATEST_TAG=$(curl https://api.github.com/repos/subspace/subspace/releases | jq --raw-output '[.[] | select(.prerelease==true) | select(.tag_name | startswith("runtime") | not) | select(.tag_name | startswith("chain-spec") | not)][0].tag_name')
   
   #Создаём папку для ноды
   DIR=$(ls ~/ | grep subspace)
   if [ -z $DIR ]; then mkdir /root/subspace; fi
   
   #Получаем какие версии у нас на ноде
   VERSION_NODE=$(ls ~/subspace/ | grep node)
   VERSION_FARMER=$(ls ~/subspace/ | grep farmer)

   #Получаем версию, которая должна быть
   LATEST_NODE=subspace-farmer-ubuntu-x86_64-$LATEST_TAG
   LATEST_FARMER=subspace-cli-ubuntu-x86_64-$LATEST_TAG
   
   #Проверяем наличие ноды, если нет - то качаем
   if [ -z $VERSION_NODE ]; then 
   cd $HOME
   wget  https://github.com/subspace/subspace/releases/download/$LATEST_TAG/subspace-node-ubuntu-x86_64-$LATEST_TAG
   chmod +x subspace*
   mv subspace-node-ubuntu-x86_64-$LATEST_TAG /root/subspace/
   fi
   
   #Проверяем наличие фармера, если нет - то качаем
   if [ -z $VERSION_FARMER ]; then 
   cd $HOME
   wget https://github.com/subspace/subspace/releases/download/$LATEST_TAG/subspace-farmer-ubuntu-x86_64-$LATEST_TAG
   chmod +x subspace*
   mv subspace-farmer-ubuntu-x86_64-$LATEST_TAG /root/subspace/
   fi
   
   
   source ~/.bash_profile
   sleep 1
   
   #Отладка
   VERSION_NODE=$(ls ~/subspace/ | grep node)
   VERSION_FARMER=$(ls ~/subspace/ | grep farmer)
   echo "Установлен Фармер - $VERSION_FARMER"
   echo "Установлена нода - $VERSION_NODE"
   echo "Сейчас автуален фармер - $LATEST_FARMER"
   echo "Сейчас актуальна нода - $LATEST_NODE"
fi
