DIR=$(ls ~/ | grep SubSpace)

if [ -z $DIR ]; then
   mkdir ~/SubSpace
fi

cp ~/subspace-sh/scripts.sh ~/SubSpace/ 
bash scripts.sh
rm -rf ~/subspace-sh/
