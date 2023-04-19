#! /bin/sh
cd ..
#get the latest code
git pull
branchName=$(git name-rev --name-only HEAD)
echo "Build from branch $branchName :" > PreProd.release-notes.txt

# source ~/.zshrc

./buildFlutter.sh

cat release-notes.txt >> PreProd.release-notes.txt

cd android || exit
echo "android here..."
#build a PreProd environment for QA to test
fastlane buildPreProdForQA
