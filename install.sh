DIR=$(ls ~/ | grep SubSpace)

if [ -z $DIR ]; then
   mkdir ~/SubSpace
fi

cp scripts.sh ~/SubSpace/ 
bash scripts.sh
rm ~/subspace-sh/
