#!/bin/bash

#color
GREEN="\033[0;32m"
DEFAULT="\033[0m"

wget https://api.github.com/repos/subspace/subspace-cli/releases
if [ -f ./releases ]; then
   LATEST_TAG=$(jq '[.[] | select(.prerelease==false) | select(.tag_name | startswith("runtime") | not) | select(.tag_name | startswith("chain-spec") | not)][0].assets[].browser_download_url' "./releases")
   echo $LATEST_TAG
fi
