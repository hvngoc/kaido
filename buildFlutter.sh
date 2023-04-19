#! /bin/sh

source ~/.zshrc

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "${GREEN}Executing flutter clean...${NC}"
flutter clean
echo ""
echo "${GREEN}Executing flutter pub get...${NC}"
flutter pub get
echo ""
echo "${GREEN}Executing flutter packages pub run build_runner build --delete-conflicting-outputs...${NC}"
flutter packages pub run build_runner build --delete-conflicting-outputs

echo "${GREEN}Mission Complete!${NC}"
