#! /bin/sh

GREEN='\033[0;32m'
NC='\033[0m' # No Color

#get the latest code
git pull
branchName=$(git name-rev --name-only HEAD)
echo "Build from branch $branchName :" > PreProd.release-notes.txt

# source ~/.zshrc

./buildFlutter.sh

cat release-notes.txt >> PreProd.release-notes.txt

cd ios || exit
echo "iOS here..."
#build a PreProd environment for QA to test
fastlane buildPreProdForQA

cd ..
cd android || exit
echo "Android here..."
#build a PreProd environment for QA to test
fastlane buildPreProdForQA

#then back out the flutter project directory
cd ..
echo "${GREEN}Mission Complete!${NC}"
