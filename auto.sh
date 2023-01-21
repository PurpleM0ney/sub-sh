#!/bin/bash

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
   
   #Получаем ИМЯ и АДРЕС пользователя
   CHCK_NAME=$(cat ~/.bash_profile | grep NAME)
   CHCK_NAME=${CHCK_NAME//NODENAME=/}
   CHCK_ADDRESS=$(cat ~/.bash_profile | grep ADDRESS)
   CHCK_ADDRESS=${CHCK_ADDRESS//ADDRESS=/}
   echo $CHCK_NAME
   echo $CHCK_ADDRESS
   
   #Проверяем наличие имени
   if [ -z $CHCK_NAME ]; then
   read -p "Дайте имя вашей ноде: " NODE_NAME
   fi
   sleep 1
   echo 'NODENAME='$NODE_NAME >> $HOME/.bash_profile
   echo -e '\n\e[42mГотово\e[0m\n'
   echo "-----------------------------------------------------------------------------"
   sleep 1
   
   #Проверяем наличие кощеля
   if [ -z $CHCK_ADDRESS ]; then
	read -p "Введите адрес кошелька : " YOUR_WALLET
   fi
   sleep 1
   echo 'ADDRESS='$YOUR_WALLET >> $HOME/.bash_profile
   echo -e '\n\e[42mГотово\e[0m\n'
   echo "-----------------------------------------------------------------------------"
   
   #Проверяем наличие ноды, если нет - то качаем
   if [ -z $VERSION_NODE ]; then 
  
   #Качаем ноду
   cd $HOME
   wget  https://github.com/subspace/subspace/releases/download/$LATEST_TAG/subspace-node-ubuntu-x86_64-$LATEST_TAG
   chmod +x subspace*
   mv subspace-node-ubuntu-x86_64-$LATEST_TAG /root/subspace/
   
   #Создаем сервисник для ноды
   echo "[Unit]
   Description=Subspace Node
   After=network.target

   [Service]
   User=$USER
   Type=simple
   ExecStart=/root/subspace/subspace-node-ubuntu-x86_64-$LATEST_TAG --chain gemini-3c --execution wasm --state-pruning archive --validator --name $SUBSPACE_NODENAME
   Restart=on-failure
   LimitNOFILE=65535

   [Install]
   WantedBy=multi-user.target" > $HOME/subspaced.service
   fi
   
   #Проверяем наличие фармера, если нет - то качаем
   if [ -z $VERSION_FARMER ]; then
   
   #Качаем фармер
   cd $HOME
   wget https://github.com/subspace/subspace/releases/download/$LATEST_TAG/subspace-farmer-ubuntu-x86_64-$LATEST_TAG
   chmod +x subspace*
   mv subspace-farmer-ubuntu-x86_64-$LATEST_TAG /root/subspace/
   
   #Создаем сервисник для Фармера
   echo "[Unit]
   Description=Subspaced Farm
   After=network.target

   [Service]
   User=$USER
   Type=simple
   ExecStart=/root/subspace/subspace-farmer-ubuntu-x86_64-$LATEST_TAG farm --reward-address $SUBSPACE_WALLET --plot-size 100G
   Restart=on-failure
   LimitNOFILE=65535

   [Install]
   WantedBy=multi-user.target" > $HOME/subspaced-farmer.service
   fi
    
   mv $HOME/subspaced* /etc/systemd/system/
   sudo systemctl restart systemd-journald
   sudo systemctl daemon-reload
   sudo systemctl enable subspaced subspaced-farmer
   sudo systemctl restart subspaced
   sleep 4
   sudo systemctl restart subspaced-farmer
   
   #Отладка
   echo -e "Проверить логи ноды можно командой - \e[7mjournalctl -u subspaced -f -o cat\e[0m"
   echo -e "Проверить логи фармера можно командой - \e[7mjournalctl -u subspaced-farmer -f -o cat\e[0m"
   VERSION_NODE=$(ls ~/subspace/ | grep node)
   VERSION_FARMER=$(ls ~/subspace/ | grep farmer)
   echo "Установлен Фармер - $VERSION_FARMER"
   echo "Установлена нода - $VERSION_NODE"
   echo "Сейчас автуален фармер - $LATEST_FARMER"
   echo "Сейчас актуальна нода - $LATEST_NODE"
fi
