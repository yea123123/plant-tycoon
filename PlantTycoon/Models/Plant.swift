//
//  Plant.swift
//  PlantTycoon
//
//  Created by Claude
//

import Foundation

enum PlantType: String, Codable, CaseIterable {
    case cactus = "Cactus"
    case fern = "Fern"
    case succulent = "Succulent"
    case orchid = "Orchid"
    case monstera = "Monstera"
    case snake = "Snake Plant"
    case pothos = "Pothos"
    case fiddle = "Fiddle Leaf Fig"
}

enum PlantRarity: String, Codable, CaseIterable {
    case common = "Common"
    case rare = "Rare"
    case epic = "Epic"

    var seedPrice: Int {
        switch self {
        case .common: return 10
        case .rare: return 50
        case .epic: return 200
        }
    }

    var sellMultiplier: Double {
        switch self {
        case .common: return 1.5
        case .rare: return 3.0
        case .epic: return 8.0
        }
    }
}

struct Plant: Identifiable, Codable {
    let id: UUID
    let type: PlantType
    let rarity: PlantRarity
    var growthStage: Double // 0.0 to 1.0
    var health: Double // 0.0 to 100.0
    var beauty: Double // 0.0 to 100.0
    var plantedDate: Date
    var lastWatered: Date?
    var lastFertilized: Date?
    var lastPruned: Date?

    init(type: PlantType, rarity: PlantRarity) {
        self.id = UUID()
        self.type = type
        self.rarity = rarity
        self.growthStage = 0.0
        self.health = 50.0
        self.beauty = 20.0
        self.plantedDate = Date()
        self.lastWatered = nil
        self.lastFertilized = nil
        self.lastPruned = nil
    }

    var basePrice: Int {
        return rarity.seedPrice
    }

    var sellPrice: Int {
        let baseValue = Double(basePrice) * rarity.sellMultiplier
        let growthBonus = max(0.1, growthStage) // Minimum 10% value
        let beautyBonus = max(0.1, beauty / 100.0)
        let healthBonus = max(0.1, health / 100.0)

        return max(1, Int(baseValue * growthBonus * beautyBonus * healthBonus))
    }

    var canWater: Bool {
        guard let lastWatered = lastWatered else { return true }
        return Date().timeIntervalSince(lastWatered) > 60 // 1 minute cooldown
    }

    var canFertilize: Bool {
        guard let lastFertilized = lastFertilized else { return true }
        return Date().timeIntervalSince(lastFertilized) > 120 // 2 minutes cooldown
    }

    var canPrune: Bool {
        guard let lastPruned = lastPruned else { return true }
        return Date().timeIntervalSince(lastPruned) > 90 // 1.5 minutes cooldown
    }

    var emoji: String {
        switch type {
        case .cactus: return "🌵"
        case .fern: return "🌿"
        case .succulent: return "🪴"
        case .orchid: return "🌺"
        case .monstera: return "🍃"
        case .snake: return "🌱"
        case .pothos: return "🌾"
        case .fiddle: return "🌳"
        }
    }

    mutating func water() {
        guard canWater else { return }
        health = min(100, health + 15)
        beauty = min(100, beauty + 5)
        lastWatered = Date()
    }

    mutating func fertilize() {
        guard canFertilize else { return }
        health = min(100, health + 10)
        beauty = min(100, beauty + 15)
        growthStage = min(1.0, growthStage + 0.1)
        lastFertilized = Date()
    }

    mutating func prune() {
        guard canPrune else { return }
        beauty = min(100, beauty + 20)
        lastPruned = Date()
    }

    mutating func updateGrowth(deltaTime: TimeInterval) {
        // Growth: 1% per minute of real time
        let growthRate = 0.01 / 60.0 // per second
        growthStage = min(1.0, growthStage + growthRate * deltaTime)

        // Health decay: -0.5% per minute
        let healthDecay = 0.005 / 60.0
        health = max(0, health - healthDecay * deltaTime)

        // Beauty increases with growth
        beauty = min(100, 20 + (growthStage * 60) + (health * 0.2))
    }
}
