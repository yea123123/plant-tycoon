//
//  PersistenceManager.swift
//  PlantTycoon
//
//  Created by Claude
//

import Foundation

struct GameData: Codable {
    var coins: Int
    var shelves: [Shelf]
    var seedInventory: SeedInventory
    var employees: [Employee]
    var locations: [Location]
    var marketTrend: MarketTrend
    var playerLevel: Int
    var totalSales: Int
    var lastUpdateDate: Date
}

class PersistenceManager {
    private let userDefaults = UserDefaults.standard
    private let gameDataKey = "PlantTycoonGameData"

    func saveGame(
        coins: Int,
        shelves: [Shelf],
        seedInventory: SeedInventory,
        employees: [Employee],
        locations: [Location],
        marketTrend: MarketTrend,
        playerLevel: Int,
        totalSales: Int,
        lastUpdateDate: Date
    ) {
        let gameData = GameData(
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

        if let encoded = try? JSONEncoder().encode(gameData) {
            userDefaults.set(encoded, forKey: gameDataKey)
        }
    }

    func loadGame() -> GameData? {
        guard let data = userDefaults.data(forKey: gameDataKey) else {
            return nil
        }

        return try? JSONDecoder().decode(GameData.self, from: data)
    }

    func exportSave() -> String {
        guard let data = userDefaults.data(forKey: gameDataKey) else {
            return "{}"
        }

        return String(data: data, encoding: .utf8) ?? "{}"
    }

    func importSave(jsonString: String, gameModel: GameModel) -> Bool {
        guard let data = jsonString.data(using: .utf8) else {
            return false
        }

        guard let gameData = try? JSONDecoder().decode(GameData.self, from: data) else {
            return false
        }

        // Update game model
        gameModel.coins = gameData.coins
        gameModel.shelves = gameData.shelves
        gameModel.seedInventory = gameData.seedInventory
        gameModel.employees = gameData.employees
        gameModel.locations = gameData.locations
        gameModel.marketTrend = gameData.marketTrend
        gameModel.playerLevel = gameData.playerLevel
        gameModel.totalSales = gameData.totalSales
        gameModel.lastUpdateDate = gameData.lastUpdateDate

        // Save to UserDefaults
        userDefaults.set(data, forKey: gameDataKey)

        return true
    }
}
