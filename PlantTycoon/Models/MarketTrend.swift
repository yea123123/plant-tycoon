//
//  MarketTrend.swift
//  PlantTycoon
//
//  Created by Claude
//

import Foundation

struct MarketTrend: Codable {
    var trendingPlant: PlantType
    var startDate: Date
    let duration: TimeInterval = 120 // 2 minutes

    init() {
        self.trendingPlant = PlantType.allCases.randomElement() ?? .cactus
        self.startDate = Date()
    }

    var isExpired: Bool {
        return Date().timeIntervalSince(startDate) > duration
    }

    func priceMultiplier(for plantType: PlantType) -> Double {
        if plantType == trendingPlant {
            return 1.5 // +50% bonus
        } else {
            return 0.8 // -20% penalty
        }
    }

    mutating func refresh() {
        self.trendingPlant = PlantType.allCases.randomElement() ?? .cactus
        self.startDate = Date()
    }
}
