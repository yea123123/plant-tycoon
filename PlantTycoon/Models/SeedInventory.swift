//
//  SeedInventory.swift
//  PlantTycoon
//
//  Created by Claude
//

import Foundation

struct SeedInventory: Codable {
    private var seedsStorage: [String: [String: Int]] = [:]

    var seeds: [PlantType: [PlantRarity: Int]] {
        get {
            var result: [PlantType: [PlantRarity: Int]] = [:]
            for (plantKey, rarities) in seedsStorage {
                if let plantType = PlantType(rawValue: plantKey) {
                    var rarityDict: [PlantRarity: Int] = [:]
                    for (rarityKey, count) in rarities {
                        if let rarity = PlantRarity(rawValue: rarityKey) {
                            rarityDict[rarity] = count
                        }
                    }
                    result[plantType] = rarityDict
                }
            }
            return result
        }
        set {
            seedsStorage = [:]
            for (plantType, rarities) in newValue {
                var rarityDict: [String: Int] = [:]
                for (rarity, count) in rarities {
                    rarityDict[rarity.rawValue] = count
                }
                seedsStorage[plantType.rawValue] = rarityDict
            }
        }
    }

    init() {
        // Initialize with some starting seeds
        for plantType in PlantType.allCases {
            var rarityDict: [String: Int] = [:]
            rarityDict[PlantRarity.common.rawValue] = 3
            rarityDict[PlantRarity.rare.rawValue] = 0
            rarityDict[PlantRarity.epic.rawValue] = 0
            seedsStorage[plantType.rawValue] = rarityDict
        }
    }

    func count(type: PlantType, rarity: PlantRarity) -> Int {
        return seedsStorage[type.rawValue]?[rarity.rawValue] ?? 0
    }

    mutating func add(type: PlantType, rarity: PlantRarity, count: Int = 1) {
        if seedsStorage[type.rawValue] == nil {
            seedsStorage[type.rawValue] = [:]
        }
        let current = seedsStorage[type.rawValue]?[rarity.rawValue] ?? 0
        seedsStorage[type.rawValue]?[rarity.rawValue] = current + count
    }

    mutating func remove(type: PlantType, rarity: PlantRarity) -> Bool {
        guard let current = seedsStorage[type.rawValue]?[rarity.rawValue], current > 0 else {
            return false
        }
        seedsStorage[type.rawValue]?[rarity.rawValue] = current - 1
        return true
    }

    func totalSeeds() -> Int {
        var total = 0
        for (_, rarities) in seedsStorage {
            for (_, count) in rarities {
                total += count
            }
        }
        return total
    }

    // Codable conformance
    enum CodingKeys: String, CodingKey {
        case seedsStorage
    }
}
