#### It is recommended to run the script from the home directory, to do this before you install it:
###### `cd ~`
#### Before running the script it is required to install the package git:
###### `sudo apt update`
###### `sudo apt install git`
*****************************************************
#### There are several scripts in the git:
###### install.sh - Basic script to run the auto update script
###### scripts.sh - Basic script for installing and automatically updating a node
###### remove.sh - Script for deleting a node and all auxiliary files (in development)

#### Installation is done with 2 commands:
###### `git clone https://github.com/PurpleM0ney/subspace-sh.git`
###### `bash subspace-sh/install.sh`

******************************************************
### ```diff - IMPORTANT!  ```
#### Enter your wallet carefully when prompted. The wallet is required both for the initial launch of the node and after the update.
#### If you enter it incorrectly - the script will not be able to start the node and errors will appear (in the future I plan to add a check for correctness of the purse)

******************************************************
#### The SubSpace directory contains an auto-update node script which is run via crontab once per hour.
#### The auto-update script checks the version of the sources with subspace-cli version, if they are different, it downloads a new release.
******************************************************
#### If you have any questions, write me:
##### Discord: Purple Money#4488
##### Telegram: @purplem0ney
##### Twitter: @Purple_M0ney
