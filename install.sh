DIR=$(ls ~/ | grep SubSpace)

if [ -z $DIR ]; then
   mkdir ~/SubSpace
fi

cp ~/subspace-sh/scripts.sh ~/SubSpace/ 
bash ~/SubSpace/scripts.sh
rm -rf ~/subspace-sh/
