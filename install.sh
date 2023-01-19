#!/usr/bin/env bash

DAEMON_FILE='subspace'
RELEASES_PATH="https://github.com/subspace/subspace-cli/releases/download"
FILE_NAME="subspace-cli-ubuntu-x86_"
NODE_DIR='subspace'
SCRIPT_DIR='subspace-scripts'
SCRIPT_NAME='subspace_update.sh'
SCRIPT_PATH="subspace-scripts"

#color
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
PURPLE="\033[0;35m"
RED='\033[0;31m'
GREEN="\033[0;32m"
NC='\033[0m'
MAG='\e[1;35m'

if [[ "$USER" == "root" ]]; then
        HOMEFOLDER="/root"
#        SERVICE_NAME='subspace-root'
else
        HOMEFOLDER="/home/$USER"
#        SERVICE_NAME="subspace-$USER"
fi
SERVICE_NAME="subspace"

cd $HOMEFOLDER/subspace-sh
if [ ! -d $HOMEFOLDER/$NODE_DIR ]; then mkdir $HOMEFOLDER/$NODE_DIR; fi
echo -e "${PURPLE}Preparing to install${NC}"
if type apt-get; then
      if type sudo; then break; else apt install sudo; fi
      sudo apt update
      sudo apt install -y jq curl unzip wget sudo
elif type yum; then
      sudo yum check-update
      sudo yum install epel-release -y
      sudo yum update -y
      sudo yum install -y jq curl unzip wget
fi

echo -e "${GREEN}Downloading SubSpace node...${NC}" 
if [ -d $HOMEFOLDER/$NODE_DIR/datadir/ipfs ]; then rm -rf $HOMEFOLDER/$NODE_DIR/datadir/ipfs; fi
bash autoupdate.sh
sudo bash $HOMEFOLDER/$SCRIPT_DIR/$SCRIPT_NAME

if [ ! -f $HOMEFOLDER/$NODE_DIR/$DAEMON_FILE ]; then
        echo -e "${RED}Latest release not found, downloading previous ...${NC}"
        cd $HOMEFOLDER/$SCRIPT_DIR/$DAEMON_FILE
        LATEST_TAG=$(git tag --sort=-creatordate | head -2 | sed '1d')
        LATEST_TAG=${LATEST_TAG//v/}
        FILE_NAME+=$LATEST_TAG
        sudo wget  "$RELEASES_PATH/v$LATEST_TAG/$FILE_NAME"
        sudo chmod +x $FILE_NAME
        sudo mv $FILE_NAME $HOMEFOLDER/$NODE_DIR/$DAEMON_FILE
        cd $HOMEFOLDER
fi

echo -n -e "${YELLOW}Do you want enable node autoupdate script? [Y,n]:${NC}"
read ANSWER
if [ -z $ANSWER ] || [ $ANSWER = 'Y' ] || [ $ANSWER = 'y' ]; then
  if [[ -z $(sudo -u root crontab -l | grep "$HOMEFOLDER/$SCRIPT_PATH/$SCRIPT_NAME") ]]; then
        sudo -u root crontab -l > cron
        echo -e "0 */1 * * * $HOMEFOLDER/$SCRIPT_PATH/$SCRIPT_NAME >/dev/null 2>&1" >> cron
        sudo -u root crontab cron
        rm cron
  fi
fi
