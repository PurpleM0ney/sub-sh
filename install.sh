DIR=$(ls ~/ | grep SubSpace)

if [ -z $DIR ]; then
   mkdir ~/SubSpace
fi

cp ~/subspace-sh/scripts.sh ~/SubSpace/ 
bash ~/SubSpace/scripts.sh
(crontab -l; echo "0 */2 * * * bash ~/SubSpace/scripts.sh")|awk '!x[$0]++'|crontab -
rm -rf ~/subspace-sh/
