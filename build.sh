#!/bin/bash

# Plant Tycoon Build Script
# This script builds the iOS app for simulator

set -e  # Exit on error

echo "🌱 Plant Tycoon Build Script"
echo "=============================="

# Configuration
SCHEME="PlantTycoon"
SIMULATOR="iPhone 15"
CONFIGURATION="Debug"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}Error: xcodebuild not found. Please install Xcode.${NC}"
    exit 1
fi

echo -e "${YELLOW}Checking Xcode version...${NC}"
xcodebuild -version

# Clean build folder
echo -e "${YELLOW}Cleaning build folder...${NC}"
xcodebuild -scheme "$SCHEME" clean

# Build for simulator
echo -e "${YELLOW}Building for iOS Simulator ($SIMULATOR)...${NC}"
xcodebuild -scheme "$SCHEME" \
    -destination "platform=iOS Simulator,name=$SIMULATOR" \
    -configuration "$CONFIGURATION" \
    build

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Build successful!${NC}"
    echo ""
    echo "To run the app:"
    echo "1. Open Xcode"
    echo "2. Select '$SIMULATOR' as the destination"
    echo "3. Press Cmd+R to run"
    echo ""
    echo "Or use: xcodebuild -scheme $SCHEME -destination 'platform=iOS Simulator,name=$SIMULATOR' run"
else
    echo -e "${RED}✗ Build failed!${NC}"
    exit 1
fi

# Optional: Archive for distribution (commented out by default)
# echo -e "${YELLOW}Creating archive...${NC}"
# xcodebuild -scheme "$SCHEME" \
#     -archivePath "./build/PlantTycoon.xcarchive" \
#     archive

echo -e "${GREEN}Done!${NC}"
