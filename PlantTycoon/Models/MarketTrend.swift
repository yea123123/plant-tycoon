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
    var duration: TimeInterval

    init() {
        self.trendingPlant = PlantType.allCases.randomElement() ?? .cactus
        self.startDate = Date()
        self.duration = 120 // 2 minutes
    }

    // Custom Codable to handle default duration
    enum CodingKeys: String, CodingKey {
        case trendingPlant
        case startDate
        case duration
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        trendingPlant = try container.decode(PlantType.self, forKey: .trendingPlant)
        startDate = try container.decode(Date.self, forKey: .startDate)
        duration = try container.decodeIfPresent(TimeInterval.self, forKey: .duration) ?? 120
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(trendingPlant, forKey: .trendingPlant)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(duration, forKey: .duration)
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
