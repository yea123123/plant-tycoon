//
//  Location.swift
//  PlantTycoon
//
//  Created by Claude
//

import Foundation

enum LocationType: String, Codable, CaseIterable {
    case greenhouse = "Greenhouse"
    case delivery = "Delivery Service"

    var cost: Int {
        switch self {
        case .greenhouse: return 800
        case .delivery: return 1500
        }
    }

    var description: String {
        switch self {
        case .greenhouse: return "Unlock 2 additional shelves"
        case .delivery: return "Passive income every 3 minutes"
        }
    }

    var emoji: String {
        switch self {
        case .greenhouse: return "🏡"
        case .delivery: return "🚚"
        }
    }
}

struct Location: Identifiable, Codable {
    let id: UUID
    let type: LocationType
    var unlocked: Bool
    var lastDelivery: Date?

    init(type: LocationType, unlocked: Bool = false) {
        self.id = UUID()
        self.type = type
        self.unlocked = unlocked
        self.lastDelivery = nil
    }

    var canDeliver: Bool {
        guard type == .delivery, unlocked else { return false }
        guard let lastDelivery = lastDelivery else { return true }
        return Date().timeIntervalSince(lastDelivery) > 180 // 3 minutes
    }

    var deliveryIncome: Int {
        return 50
    }
}
