# Plant Tycoon 🌱

A passive income tycoon game for iOS where you manage a plant shop, grow plants, and sell them for profit.

## Features

- 🪴 **Plant Management**: Grow 8 different types of plants with 3 rarity levels
- 💰 **Economy System**: Buy seeds, sell plants, and manage your shop
- 📈 **Market Trends**: Dynamic pricing based on trending plants (changes every 2 minutes)
- 👨‍🌾 **Automation**: Hire employees to automate watering and sales
- 🏡 **Locations**: Unlock greenhouse for more shelves and delivery service for passive income
- 📊 **Progression**: Level up based on total sales
- 💾 **Save System**: Auto-save with export/import functionality
- ⏱️ **Offline Progress**: Plants continue growing while you're away

## Requirements

- iOS 16.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later

## Installation

### Option 1: Open in Xcode

1. Clone or download this repository
2. Open `PlantTycoon.xcodeproj` in Xcode (you'll need to create this - see below)
3. Select your target device or simulator
4. Press `Cmd + R` to build and run

### Option 2: Create Xcode Project from Source

Since the `.xcodeproj` file is not included in the repository, you need to create it:

1. Open Xcode
2. Select **File → New → Project**
3. Choose **iOS → App**
4. Set the following:
   - Product Name: `PlantTycoon`
   - Interface: `SwiftUI`
   - Language: `Swift`
   - Minimum Deployment: `iOS 16.0`
5. Save the project in the `tycoon` directory
6. Delete the default `ContentView.swift` and `PlantTycoonApp.swift` files that Xcode created
7. Add all the source files from the `PlantTycoon` folder to your project:
   - Right-click on the project navigator
   - Select **Add Files to "PlantTycoon"**
   - Select the entire `PlantTycoon` folder
   - Make sure "Copy items if needed" is checked
   - Click "Add"

## Project Structure

```
PlantTycoon/
├── PlantTycoonApp.swift          # App entry point
├── Models/
│   ├── Plant.swift               # Plant entity with growth mechanics
│   ├── Shelf.swift               # Shelf container for plants
│   ├── Employee.swift            # Employee automation
│   ├── Location.swift            # Unlockable locations
│   ├── MarketTrend.swift         # Dynamic market system
│   └── SeedInventory.swift       # Seed storage
├── ViewModels/
│   └── GameModel.swift           # Main game state (MVVM)
├── Views/
│   ├── ContentView.swift         # Main navigation
│   ├── ShelvesView.swift         # Plant management UI
│   ├── PlantSelectorView.swift   # Seed planting UI
│   ├── ShopView.swift            # Purchase seeds/employees/locations
│   └── StatsView.swift           # Statistics and save management
└── Services/
    └── PersistenceManager.swift  # Save/load functionality
```

## Building from Command Line

### Build for Simulator

```bash
xcodebuild -scheme PlantTycoon \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  clean build
```

### Build for Device

```bash
xcodebuild -scheme PlantTycoon \
  -destination 'generic/platform=iOS' \
  clean build
```

### Run Tests

```bash
xcodebuild test -scheme PlantTycoon \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Using the Build Script

A convenience script is provided:

```bash
chmod +x build.sh
./build.sh
```

## Gameplay Guide

### Getting Started

1. You start with 100 coins and some common seeds
2. Plant seeds on your shelves (max 6 plants per shelf)
3. Water 💧, fertilize 🌱, and prune ✂️ your plants to increase their stats
4. Sell plants when their beauty reaches 80% for maximum profit

### Plant Stats

- **Growth**: Increases over time (0-100%)
- **Health**: Decreases slowly, increased by watering and fertilizing
- **Beauty**: Determines sell price, increased by all actions

### Market Trends

Every 2 minutes, a random plant type becomes trending:
- Trending plant: +50% sell price
- Other plants: -20% sell price

### Employees

- **Gardener** (500 coins): Auto-waters all plants every hour
- **Marketer** (1000 coins): Sells plants at 70% price automatically when beauty ≥ 80%

### Locations

- **Greenhouse** (800 coins): Unlocks 2 additional shelves
- **Delivery Service** (1500 coins): Passive income of 50 coins every 3 minutes

### Progression

- Level up every 1000 coins in total sales
- Unlock better strategies as you progress
- Aim for rare and epic plants for higher profits

## Save Management

### Auto-Save

The game automatically saves:
- When you close the app
- Periodically during gameplay

### Export/Import

1. Go to the **Stats** tab
2. Tap **Export Save** to copy your save data
3. Paste it into a text file for backup
4. Use **Import Save** to restore from a backup

## GitHub Actions CI/CD

To set up automated builds with GitHub Actions, create `.github/workflows/ios.yml`:

```yaml
name: iOS Build

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: macos-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Select Xcode
      run: sudo xcode-select -s /Applications/Xcode_15.0.app
    
    - name: Build
      run: |
        xcodebuild -scheme PlantTycoon \
          -destination 'platform=iOS Simulator,name=iPhone 15' \
          clean build
    
    - name: Run Tests
      run: |
        xcodebuild test -scheme PlantTycoon \
          -destination 'platform=iOS Simulator,name=iPhone 15'
```

**Note**: Build artifacts (`.app`, `.ipa`) are not stored in the repository. Only source code is committed.

## Development

### Architecture

The project follows **MVVM** (Model-View-ViewModel) architecture:

- **Models**: Pure data structures (Plant, Shelf, Employee, etc.)
- **ViewModels**: Business logic and state management (GameModel)
- **Views**: SwiftUI views that observe the GameModel
- **Services**: Utility services (PersistenceManager)

### Adding New Features

1. Add model changes in `Models/`
2. Update `GameModel.swift` with new logic
3. Create or update views in `Views/`
4. Update `PersistenceManager.swift` if save format changes

### Testing

The game uses real-time mechanics with accelerated timers:
- Plant growth: 1% per minute
- Market trends: 2 minutes
- Employee actions: 1 hour (for gardener/marketer)
- Delivery: 3 minutes

Adjust these values in the respective model files for testing.

## Troubleshooting

### Build Errors

- Ensure you're using Xcode 15.0 or later
- Check that iOS deployment target is set to 16.0
- Clean build folder: `Cmd + Shift + K`

### Runtime Issues

- Check console logs for errors
- Verify UserDefaults permissions
- Reset simulator if needed: `Device → Erase All Content and Settings`

### Save Data Issues

- Export your save before updating the app
- If import fails, check JSON format validity
- UserDefaults key: `PlantTycoonGameData`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is provided as-is for educational purposes.

## Credits

Developed with SwiftUI and ❤️ by Claude

---

**Enjoy growing your plant empire! 🌱💰**
