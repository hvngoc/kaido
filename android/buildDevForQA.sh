#! /bin/sh
cd ..
#get the latest code
git pull
branchName=$(git name-rev --name-only HEAD)
echo "Build from branch $branchName :" > Dev.release-notes.txt

# source ~/.zshrc

./buildFlutter.sh

cat release-notes.txt >> Dev.release-notes.txt

cd android || exit
echo "android here..."
#build a dev environment for QA to test
fastlane buildDevForQA
