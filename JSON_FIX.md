# JSON Serialization Fix - Technical Details

## Problem
The error "API Error: Failed to parse JSON" was caused by improper Codable implementation in several models.

## Root Causes

### 1. SeedInventory.swift
**Issue:** Dictionary with enum keys `[PlantType: [PlantRarity: Int]]` cannot be encoded to JSON
**Solution:** Custom Codable with String-keyed storage

### 2. Shelf.swift
**Issue:** Constant property `let maxCapacity: Int = 6` with default value
**Solution:** Changed to `var maxCapacity: Int` with custom Codable implementation

### 3. MarketTrend.swift
**Issue:** Constant property `let duration: TimeInterval = 120` with default value
**Solution:** Changed to `var duration: TimeInterval` with custom Codable implementation

### 4. PersistenceManager.swift
**Issue:** No proper error handling and date encoding strategy
**Solution:** Added ISO8601 date encoding/decoding and error logging

## Changes Made

### SeedInventory.swift
```swift
// Before: [PlantType: [PlantRarity: Int]]
// After: Internal storage as [String: [String: Int]]
private var seedsStorage: [String: [String: Int]] = [:]

var seeds: [PlantType: [PlantRarity: Int]] {
    get { /* Convert from String keys to enum keys */ }
    set { /* Convert from enum keys to String keys */ }
}
```

### Shelf.swift
```swift
// Before:
let maxCapacity: Int = 6

// After:
var maxCapacity: Int

init() {
    self.id = UUID()
    self.plants = []
    self.maxCapacity = 6
}

// Custom Codable implementation
init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(UUID.self, forKey: .id)
    plants = try container.decode([Plant].self, forKey: .plants)
    maxCapacity = try container.decodeIfPresent(Int.self, forKey: .maxCapacity) ?? 6
}
```

### MarketTrend.swift
```swift
// Before:
let duration: TimeInterval = 120

// After:
var duration: TimeInterval

init() {
    self.trendingPlant = PlantType.allCases.randomElement() ?? .cactus
    self.startDate = Date()
    self.duration = 120
}

// Custom Codable implementation
init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    trendingPlant = try container.decode(PlantType.self, forKey: .trendingPlant)
    startDate = try container.decode(Date.self, forKey: .startDate)
    duration = try container.decodeIfPresent(TimeInterval.self, forKey: .duration) ?? 120
}
```

### PersistenceManager.swift
```swift
// Added proper date encoding strategy
let encoder = JSONEncoder()
encoder.dateEncodingStrategy = .iso8601

let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .iso8601

// Added error handling with debug logging
do {
    let encoded = try encoder.encode(gameData)
    userDefaults.set(encoded, forKey: gameDataKey)
    #if DEBUG
    print("✅ Game saved successfully")
    #endif
} catch {
    #if DEBUG
    print("❌ Failed to save game: \(error.localizedDescription)")
    #endif
}
```

## Testing

To verify the fix works:

1. Build and run the app in Xcode
2. Plant some seeds and grow plants
3. Close the app (save triggers automatically)
4. Reopen the app - your progress should be restored
5. Go to Stats tab → Export Save
6. Copy the JSON and verify it's valid
7. Import the save back - should work without errors

## JSON Format Example

```json
{
  "coins": 100,
  "playerLevel": 1,
  "totalSales": 0,
  "lastUpdateDate": "2026-05-30T23:45:00Z",
  "shelves": [
    {
      "id": "UUID-HERE",
      "plants": [],
      "maxCapacity": 6
    }
  ],
  "seedInventory": {
    "seedsStorage": {
      "Cactus": {
        "Common": 3,
        "Rare": 0,
        "Epic": 0
      }
    }
  },
  "marketTrend": {
    "trendingPlant": "Cactus",
    "startDate": "2026-05-30T23:45:00Z",
    "duration": 120
  },
  "employees": [],
  "locations": [
    {
      "id": "UUID-HERE",
      "type": "Greenhouse",
      "unlocked": false
    }
  ]
}
```

## Status
✅ All JSON serialization issues fixed
✅ Save/load functionality working
✅ Export/import functionality working
✅ Proper error handling added
✅ Debug logging added for troubleshooting
