#!/bin/bash

#color
GREEN="\033[0;32m"
DEFAULT="\033[0m"

wget https://api.github.com/repos/subspace/subspace-cli/releases
if [ -f ./releases ]; then
   LATEST_TAG=$(curl https://api.github.com/repos/subspace/subspace/releases | jq '[.[] | select(.prerelease==false) | select(.tag_name | startswith("runtime") | not) | select(.tag_name | startswith("chain-spec") | not)][0].assets[].browser_download_url')
   echo $LATEST_TAG
fi
