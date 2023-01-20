#!/bin/bash

   #Узнаем адрес ноды и записываем в CHCK_ADDRESS
   CHCK_ADDRESS=$(head data.txt | grep ADDRESS)
   CHCK_ADDRESS=${CHCK_ADDRESS//ADDRESS=/}
   echo "Ваш кошелек $CHCK_ADDRESS"
   
   sleep 5
      echo $CHCK_ADDRESS
