#! /bin/sh
cd ..
#get the latest code
git pull
branchName=$(git name-rev --name-only HEAD)
echo "Build from branch $branchName :" > Staging.release-notes.txt

# source ~/.zshrc

./buildFlutter.sh

cat release-notes.txt >> Staging.release-notes.txt

cd android || exit
echo "android here..."
#build a Staging environment for QA to test
fastlane buildStagingForQA
