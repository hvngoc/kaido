#! /bin/sh
cd ..
#get the latest code
git pull
branchName=$(git name-rev --name-only HEAD)
echo "Build from branch $branchName :" > Dev.release-notes.txt

# source ~/.zshrc

echo "Executing flutter clean..."
flutter clean
echo "Executing flutter pub get..."
flutter pub get
echo "Executing flutter packages pub run build_runner build --delete-conflicting-outputs..."
flutter packages pub run build_runner build --delete-conflicting-outputs

cat release-notes.txt >> Dev.release-notes.txt

cd ios || exit
echo "iOS here..."
#build a dev environment for QA to test
fastlane buildDevForQA
