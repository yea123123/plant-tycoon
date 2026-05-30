# Plant Tycoon - Quick Start Guide

## 🚀 Getting Started in 5 Minutes

### Step 1: Create Xcode Project

1. Open **Xcode**
2. **File → New → Project**
3. Select **iOS → App**
4. Configure:
   - Product Name: `PlantTycoon`
   - Team: Your team (or leave as None for simulator)
   - Organization Identifier: `com.yourname.planttycoon`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: None
   - Minimum Deployment: **iOS 16.0**
5. Save in the `tycoon` directory (where this README is located)

### Step 2: Add Source Files

1. In Xcode, **delete** the default `ContentView.swift` and `PlantTycoonApp.swift` files
2. Right-click on the `PlantTycoon` folder in the Project Navigator
3. Select **Add Files to "PlantTycoon"...**
4. Navigate to the `PlantTycoon` folder containing all the source files
5. Select the entire folder
6. ✅ Check "Copy items if needed"
7. ✅ Check "Create groups"
8. Click **Add**

### Step 3: Run the App

1. Select a simulator (e.g., iPhone 15)
2. Press **⌘ + R** (or click the Play button)
3. The app should build and launch! 🎉

## 📱 First Time Playing

When you launch the app:
- You start with **100 coins** and some **common seeds**
- Go to **Shelves** tab and tap **➕** to plant your first seed
- Tap the plant to **water** 💧, **fertilize** 🌱, or **prune** ✂️
- Watch your plant grow in real-time!
- When **Beauty ≥ 80%**, sell for maximum profit
- Use coins to buy more seeds in the **Shop** tab

## 🎮 Game Mechanics

### Plant Care Actions
- **Water** 💧: +15 health, +5 beauty (1 min cooldown)
- **Fertilize** 🌱: +10 health, +15 beauty, +10% growth (2 min cooldown)
- **Prune** ✂️: +20 beauty (1.5 min cooldown)

### Automatic Growth
- Plants grow **1% per minute** automatically
- Health decays **0.5% per minute** (water regularly!)
- Beauty increases with growth and health

### Market Trends (Every 2 Minutes)
- One plant type gets **+50% sell price** 📈
- Other plants get **-20% sell price** 📉
- Check the **Stats** tab to see current trend

### Employees (Automation)
- **Gardener** (500 coins): Auto-waters all plants every hour
- **Marketer** (1000 coins): Auto-sells plants at 70% price when beauty ≥ 80%

### Locations (Expansion)
- **Greenhouse** (800 coins): +2 shelves (12 more plant slots!)
- **Delivery Service** (1500 coins): Passive income of 50 coins every 3 minutes

## 💡 Pro Tips

1. **Focus on rare/epic plants** - They have higher sell multipliers
2. **Watch the market trend** - Sell trending plants for +50% profit
3. **Hire the gardener first** - Saves you from manual watering
4. **Unlock greenhouse early** - More plants = more income
5. **Keep plants until beauty ≥ 80%** - Maximum profit!

## 🐛 Troubleshooting

### "No such module 'SwiftUI'"
- Make sure iOS Deployment Target is set to 16.0 or higher
- Check that you're building for iOS (not macOS)

### App crashes on launch
- Clean build folder: **⌘ + Shift + K**
- Reset simulator: **Device → Erase All Content and Settings**

### Plants not growing
- Check that the app is running (not paused in debugger)
- The timer updates every second - give it a moment

### Can't add files to Xcode
- Make sure you're adding to the correct target
- Check that "PlantTycoon" target is selected when adding files

## 📦 Project Structure

```
PlantTycoon/
├── PlantTycoonApp.swift          # Entry point
├── Models/                       # Data structures
│   ├── Plant.swift
│   ├── Shelf.swift
│   ├── Employee.swift
│   ├── Location.swift
│   ├── MarketTrend.swift
│   └── SeedInventory.swift
├── ViewModels/                   # Business logic
│   └── GameModel.swift
├── Views/                        # UI components
│   ├── ContentView.swift
│   ├── ShelvesView.swift
│   ├── PlantSelectorView.swift
│   ├── ShopView.swift
│   └── StatsView.swift
└── Services/                     # Utilities
    └── PersistenceManager.swift
```

## 🔧 Development

### Run from Command Line
```bash
xcodebuild -scheme PlantTycoon \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  build
```

### Use Build Script
```bash
chmod +x build.sh
./build.sh
```

## 💾 Save System

- **Auto-save**: Happens automatically when you close the app
- **Export**: Stats tab → Export Save → Copy to clipboard
- **Import**: Stats tab → Import Save → Paste your save data
- **Offline Progress**: Plants continue growing while app is closed!

## 🎯 Goals

- Reach **Level 10** (10,000 total sales)
- Unlock all locations
- Hire all employees
- Collect all plant types
- Master the market trends

---

**Need help?** Check the main [README.md](README.md) for detailed documentation.

**Enjoy the game! 🌱💰**
