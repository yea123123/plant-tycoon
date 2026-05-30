# Xcode Project Setup Instructions

## Step-by-Step Guide to Create the Xcode Project

Since `.xcodeproj` files are binary and not suitable for Git, follow these steps to create the project:

### 1. Create New Xcode Project

1. Open **Xcode**
2. Select **File → New → Project** (or press `⌘ + Shift + N`)
3. Choose **iOS** tab at the top
4. Select **App** template
5. Click **Next**

### 2. Configure Project Settings

Fill in the following details:

- **Product Name**: `PlantTycoon`
- **Team**: Select your team (or leave as "None" for simulator testing)
- **Organization Identifier**: `com.yourname` (or your preferred identifier)
- **Bundle Identifier**: Will auto-generate as `com.yourname.PlantTycoon`
- **Interface**: **SwiftUI** ⚠️ Important!
- **Language**: **Swift** ⚠️ Important!
- **Storage**: None (uncheck Core Data)
- **Include Tests**: Optional (you can check this if you want)

Click **Next**

### 3. Save Project Location

- Navigate to the `tycoon` folder (where this README is located)
- **Important**: Save the project directly in the `tycoon` folder, NOT in a subfolder
- Click **Create**

Your folder structure should look like:
```
tycoon/
├── PlantTycoon/           # Source files (already exists)
├── PlantTycoon.xcodeproj/ # Created by Xcode
├── README.md
├── build.sh
└── .gitignore
```

### 4. Remove Default Files

Xcode creates some default files we don't need:

1. In the Project Navigator (left sidebar), find these files:
   - `ContentView.swift` (in the PlantTycoon group)
   - `PlantTycoonApp.swift` (in the PlantTycoon group)
2. Right-click each file → **Delete**
3. Choose **Move to Trash** (not just remove reference)

### 5. Add Source Files

Now add our actual source files:

1. Right-click on the **PlantTycoon** folder (blue icon) in Project Navigator
2. Select **Add Files to "PlantTycoon"...**
3. Navigate to the `PlantTycoon` folder containing all the Swift files
4. Select the **PlantTycoon** folder (the one with Models, Views, etc.)
5. **Important**: Check these options:
   - ✅ **Copy items if needed**
   - ✅ **Create groups** (not folder references)
   - ✅ **Add to targets: PlantTycoon**
6. Click **Add**

### 6. Verify File Structure

Your Project Navigator should now show:

```
PlantTycoon
├── PlantTycoonApp.swift
├── Models
│   ├── Employee.swift
│   ├── Location.swift
│   ├── MarketTrend.swift
│   ├── Plant.swift
│   ├── SeedInventory.swift
│   └── Shelf.swift
├── ViewModels
│   └── GameModel.swift
├── Views
│   ├── ContentView.swift
│   ├── PlantSelectorView.swift
│   ├── ShelvesView.swift
│   ├── ShopView.swift
│   └── StatsView.swift
├── Services
│   └── PersistenceManager.swift
└── Assets.xcassets
```

### 7. Configure Build Settings

1. Click on the **PlantTycoon** project (blue icon at the top of Project Navigator)
2. Select the **PlantTycoon** target (under TARGETS)
3. Go to **General** tab
4. Verify these settings:
   - **Minimum Deployments**: iOS 16.0
   - **iPhone Orientation**: Portrait (default is fine)
   - **Supports multiple windows**: Unchecked

### 8. Build and Run

1. Select a simulator from the device menu (e.g., **iPhone 15**)
2. Press **⌘ + B** to build (or **Product → Build**)
3. If build succeeds, press **⌘ + R** to run (or click the Play button)

### 9. First Launch

The app should launch in the simulator with:
- Dark theme
- 100 coins
- Empty shelves
- Some starting seeds

## Troubleshooting

### "Cannot find 'X' in scope"

This usually means files weren't added to the target:

1. Select the file in Project Navigator
2. Open **File Inspector** (right sidebar, first tab)
3. Under **Target Membership**, check **PlantTycoon**

### "No such module 'SwiftUI'"

1. Select the project → Target → Build Settings
2. Search for "iOS Deployment Target"
3. Set it to **16.0** or higher

### Build Errors

1. Clean build folder: **⌘ + Shift + K**
2. Clean derived data: **⌘ + Shift + Option + K**
3. Restart Xcode

### Simulator Issues

1. Reset simulator: **Device → Erase All Content and Settings**
2. Quit and restart Simulator app
3. Try a different simulator device

## Git Setup

After creating the project:

```bash
# Initialize git (if not already done)
git init

# Add files
git add .

# Commit
git commit -m "Initial commit: Plant Tycoon iOS game"

# Add remote (replace with your repo URL)
git remote add origin https://github.com/yourusername/plant-tycoon.git

# Push
git push -u origin main
```

The `.gitignore` file is already configured to exclude:
- `xcuserdata/` (user-specific settings)
- `build/` and `DerivedData/` (build artifacts)
- `.DS_Store` (macOS files)

## Command Line Build

After project setup, you can build from terminal:

```bash
# Build for simulator
xcodebuild -scheme PlantTycoon \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  clean build

# Or use the provided script
chmod +x build.sh
./build.sh
```

## Next Steps

1. ✅ Create Xcode project (you just did this!)
2. ✅ Build and run
3. 🎮 Play the game
4. 📝 Read [QUICKSTART.md](QUICKSTART.md) for gameplay tips
5. 🚀 Check [CONTRIBUTING.md](CONTRIBUTING.md) if you want to contribute

---

**Need help?** Open an issue on GitHub or check the main [README.md](README.md)
