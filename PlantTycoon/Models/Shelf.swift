//
//  Shelf.swift
//  PlantTycoon
//
//  Created by Claude
//

import Foundation

struct Shelf: Identifiable, Codable {
    let id: UUID
    var plants: [Plant]
    var maxCapacity: Int

    init() {
        self.id = UUID()
        self.plants = []
        self.maxCapacity = 6
    }

    // Custom Codable to handle default maxCapacity
    enum CodingKeys: String, CodingKey {
        case id
        case plants
        case maxCapacity
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        plants = try container.decode([Plant].self, forKey: .plants)
        maxCapacity = try container.decodeIfPresent(Int.self, forKey: .maxCapacity) ?? 6
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(plants, forKey: .plants)
        try container.encode(maxCapacity, forKey: .maxCapacity)
    }

    var hasSpace: Bool {
        return plants.count < maxCapacity
    }

    mutating func addPlant(_ plant: Plant) -> Bool {
        guard hasSpace else { return false }
        plants.append(plant)
        return true
    }

    mutating func removePlant(at index: Int) -> Plant? {
        guard index < plants.count else { return nil }
        return plants.remove(at: index)
    }

    mutating func waterAll() {
        for i in 0..<plants.count {
            plants[i].water()
        }
    }

    mutating func fertilizeAll() {
        for i in 0..<plants.count {
            plants[i].fertilize()
        }
    }

    mutating func pruneAll() {
        for i in 0..<plants.count {
            plants[i].prune()
        }
    }
}
