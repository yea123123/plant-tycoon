//
//  Employee.swift
//  PlantTycoon
//
//  Created by Claude
//

import Foundation

enum EmployeeType: String, Codable, CaseIterable {
    case gardener = "Gardener"
    case marketer = "Marketer"

    var cost: Int {
        switch self {
        case .gardener: return 500
        case .marketer: return 1000
        }
    }

    var description: String {
        switch self {
        case .gardener: return "Auto-waters plants every hour"
        case .marketer: return "Passive sales at 70% price"
        }
    }

    var emoji: String {
        switch self {
        case .gardener: return "👨‍🌾"
        case .marketer: return "📢"
        }
    }
}

struct Employee: Identifiable, Codable {
    let id: UUID
    let type: EmployeeType
    var hiredDate: Date
    var lastAction: Date?

    init(type: EmployeeType) {
        self.id = UUID()
        self.type = type
        self.hiredDate = Date()
        self.lastAction = nil
    }

    var canPerformAction: Bool {
        guard let lastAction = lastAction else { return true }
        return Date().timeIntervalSince(lastAction) > 3600 // 1 hour
    }
}
