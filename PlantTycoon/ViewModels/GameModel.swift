//
//  GameModel.swift
//  PlantTycoon
//
//  Created by Claude
//

import Foundation
import SwiftUI

class GameModel: ObservableObject {
    @Published var coins: Int = 100
    @Published var shelves: [Shelf] = []
    @Published var seedInventory = SeedInventory()
    @Published var employees: [Employee] = []
    @Published var locations: [Location] = []
    @Published var marketTrend = MarketTrend()
    @Published var playerLevel: Int = 1
    @Published var totalSales: Int = 0
    @Published var lastUpdateDate: Date = Date()

    private let persistenceManager = PersistenceManager()
    private var updateTimer: Timer?

    init() {
        // Initialize with 2 shelves
        shelves = [Shelf(), Shelf()]

        // Initialize locations
        locations = [
            Location(type: .greenhouse, unlocked: false),
            Location(type: .delivery, unlocked: false)
        ]

        // Start update timer
        startUpdateTimer()
    }

    func startUpdateTimer() {
        updateTimer?.invalidate()
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateGame()
        }
    }

    func updateGame() {
        let now = Date()
        let deltaTime = now.timeIntervalSince(lastUpdateDate)
        lastUpdateDate = now

        // Update all plants
        for shelfIndex in 0..<shelves.count {
            for plantIndex in 0..<shelves[shelfIndex].plants.count {
                shelves[shelfIndex].plants[plantIndex].updateGrowth(deltaTime: deltaTime)
            }
        }

        // Check market trend
        if marketTrend.isExpired {
            marketTrend.refresh()
        }

        // Auto-water from gardener
        if let gardener = employees.first(where: { $0.type == .gardener }) {
            if gardener.canPerformAction {
                autoWaterPlants()
                if let index = employees.firstIndex(where: { $0.id == gardener.id }) {
                    employees[index].lastAction = Date()
                }
            }
        }

        // Passive sales from marketer
        if let marketer = employees.first(where: { $0.type == .marketer }) {
            if marketer.canPerformAction {
                performPassiveSales()
                if let index = employees.firstIndex(where: { $0.id == marketer.id }) {
                    employees[index].lastAction = Date()
                }
            }
        }

        // Delivery income
        if let deliveryLocation = locations.first(where: { $0.type == .delivery }) {
            if deliveryLocation.canDeliver {
                coins += deliveryLocation.deliveryIncome
                if let index = locations.firstIndex(where: { $0.id == deliveryLocation.id }) {
                    locations[index].lastDelivery = Date()
                }
            }
        }
    }

    func plantSeed(type: PlantType, rarity: PlantRarity, shelfIndex: Int) -> Bool {
        guard shelfIndex < shelves.count else { return false }
        guard shelves[shelfIndex].hasSpace else { return false }
        guard seedInventory.remove(type: type, rarity: rarity) else { return false }

        let plant = Plant(type: type, rarity: rarity)
        return shelves[shelfIndex].addPlant(plant)
    }

    func sellPlant(shelfIndex: Int, plantIndex: Int) {
        guard shelfIndex < shelves.count else { return }
        guard let plant = shelves[shelfIndex].removePlant(at: plantIndex) else { return }

        let trendMultiplier = marketTrend.priceMultiplier(for: plant.type)
        let finalPrice = Int(Double(plant.sellPrice) * trendMultiplier)

        coins += finalPrice
        totalSales += finalPrice

        // Level up every 1000 coins in sales
        let newLevel = (totalSales / 1000) + 1
        if newLevel > playerLevel {
            playerLevel = newLevel
        }
    }

    func buySeeds(type: PlantType, rarity: PlantRarity, count: Int = 1) -> Bool {
        let cost = rarity.seedPrice * count
        guard coins >= cost else { return false }

        coins -= cost
        seedInventory.add(type: type, rarity: rarity, count: count)
        return true
    }

    func hireEmployee(type: EmployeeType) -> Bool {
        // Check if already hired
        if employees.contains(where: { $0.type == type }) {
            return false
        }

        guard coins >= type.cost else { return false }

        coins -= type.cost
        employees.append(Employee(type: type))
        return true
    }

    func unlockLocation(type: LocationType) -> Bool {
        guard let index = locations.firstIndex(where: { $0.type == type }) else { return false }
        guard !locations[index].unlocked else { return false }
        guard coins >= type.cost else { return false }

        coins -= type.cost
        locations[index].unlocked = true

        // Add shelves if greenhouse
        if type == .greenhouse {
            shelves.append(Shelf())
            shelves.append(Shelf())
        }

        return true
    }

    func waterPlant(shelfIndex: Int, plantIndex: Int) {
        guard shelfIndex < shelves.count else { return }
        guard plantIndex < shelves[shelfIndex].plants.count else { return }
        shelves[shelfIndex].plants[plantIndex].water()
    }

    func fertilizePlant(shelfIndex: Int, plantIndex: Int) {
        guard shelfIndex < shelves.count else { return }
        guard plantIndex < shelves[shelfIndex].plants.count else { return }
        shelves[shelfIndex].plants[plantIndex].fertilize()
    }

    func prunePlant(shelfIndex: Int, plantIndex: Int) {
        guard shelfIndex < shelves.count else { return }
        guard plantIndex < shelves[shelfIndex].plants.count else { return }
        shelves[shelfIndex].plants[plantIndex].prune()
    }

    private func autoWaterPlants() {
        for shelfIndex in 0..<shelves.count {
            for plantIndex in 0..<shelves[shelfIndex].plants.count {
                if shelves[shelfIndex].plants[plantIndex].canWater {
                    shelves[shelfIndex].plants[plantIndex].water()
                }
            }
        }
    }

    private func performPassiveSales() {
        var soldPlants: [(shelfIndex: Int, plantIndex: Int)] = []

        for shelfIndex in 0..<shelves.count {
            for plantIndex in 0..<shelves[shelfIndex].plants.count {
                let plant = shelves[shelfIndex].plants[plantIndex]
                if plant.beauty >= 80 {
                    let trendMultiplier = marketTrend.priceMultiplier(for: plant.type)
                    let finalPrice = Int(Double(plant.sellPrice) * trendMultiplier * 0.7) // 70% price
                    coins += finalPrice
                    totalSales += finalPrice
                    soldPlants.append((shelfIndex, plantIndex))
                }
            }
        }

        // Remove sold plants (reverse order to maintain indices)
        for (shelfIndex, plantIndex) in soldPlants.reversed() {
            _ = shelves[shelfIndex].removePlant(at: plantIndex)
        }
    }

    func saveGame() {
        persistenceManager.saveGame(
            coins: coins,
            shelves: shelves,
            seedInventory: seedInventory,
            employees: employees,
            locations: locations,
            marketTrend: marketTrend,
            playerLevel: playerLevel,
            totalSales: totalSales,
            lastUpdateDate: lastUpdateDate
        )
    }

    func loadGame() {
        if let gameData = persistenceManager.loadGame() {
            self.coins = gameData.coins
            self.shelves = gameData.shelves
            self.seedInventory = gameData.seedInventory
            self.employees = gameData.employees
            self.locations = gameData.locations
            self.marketTrend = gameData.marketTrend
            self.playerLevel = gameData.playerLevel
            self.totalSales = gameData.totalSales
            self.lastUpdateDate = gameData.lastUpdateDate

            // Calculate offline progress
            let offlineTime = Date().timeIntervalSince(lastUpdateDate)
            if offlineTime > 0 {
                updateOfflineProgress(deltaTime: offlineTime)
            }
        }
    }

    private func updateOfflineProgress(deltaTime: TimeInterval) {
        // Update all plants with offline time
        for shelfIndex in 0..<shelves.count {
            for plantIndex in 0..<shelves[shelfIndex].plants.count {
                shelves[shelfIndex].plants[plantIndex].updateGrowth(deltaTime: deltaTime)
            }
        }

        // Calculate delivery income
        if let deliveryLocation = locations.first(where: { $0.type == .delivery && $0.unlocked }) {
            let deliveries = Int(deltaTime / 180) // Every 3 minutes
            coins += deliveries * deliveryLocation.deliveryIncome
        }

        lastUpdateDate = Date()
    }

    func exportSave() -> String {
        return persistenceManager.exportSave()
    }

    func importSave(jsonString: String) -> Bool {
        return persistenceManager.importSave(jsonString: jsonString, gameModel: self)
    }
}
