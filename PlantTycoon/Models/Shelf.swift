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
    let maxCapacity: Int = 6

    init() {
        self.id = UUID()
        self.plants = []
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
