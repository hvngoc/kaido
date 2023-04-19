#! /bin/sh

GREEN='\033[0;32m'
NC='\033[0m' # No Color

#get the latest code
git pull
branchName=$(git name-rev --name-only HEAD)
echo "Build from branch $branchName :" > Production.release-notes.txt

# source ~/.zshrc

./buildFlutter.sh

cat release-notes.txt >> Production.release-notes.txt

cd ios || exit
echo "iOS here..."
#build a Production environment for QA to test
fastlane release

cd ..
cd android || exit
echo "Android here..."
#build a Production environment for QA to test
fastlane buildProductionForQA

#then back out the flutter project directory
cd ..
echo "${GREEN}Mission Complete!${NC}"
