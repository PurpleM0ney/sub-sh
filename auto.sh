#!/bin/bash

#color
GREEN="\033[0;32m"
DEFAULT="\033[0m"

wget https://api.github.com/repos/subspace/subspace-cli/releases
if [ -f ./releases ]; then
   LATEST_TAG=$(curl https://api.github.com/repos/subspace/subspace/releases | jq '[.[] | select(.prerelease==false) | select(.tag_name | startswith("runtime") | not) | select(.tag_name | startswith("chain-spec") | not)][0].tag_name')
   echo $LATEST_TAG
   LATEST_TAG=$(LATEST_TAG|sed 's/\"//g')
   echo $LATEST_TAG
   
   VERSION_NODE=$(ls ~/subspace-sh/sub/ | grep node)
   VERSION_FARMER=$(ls ~/subspace-sh/sub/ | grep farmer)
   
   LATEST_NODE=subspace-farmer-ubuntu-x86_64-$LATEST_TAG
   LATEST_FARMER=subspace-cli-ubuntu-x86_64-$LATEST_TAG
   
   echo $VERSION_FARMER
   echo $VERSION_NODE
   echo "Farmer $LATEST_FARMER"
   echo "Node $LATEST_NODE"
fi
