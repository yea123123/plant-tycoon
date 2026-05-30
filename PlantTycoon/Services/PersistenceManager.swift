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

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        do {
            let encoded = try encoder.encode(gameData)
            userDefaults.set(encoded, forKey: gameDataKey)
            #if DEBUG
            print("✅ Game saved successfully")
            #endif
        } catch {
            #if DEBUG
            print("❌ Failed to save game: \(error.localizedDescription)")
            #endif
        }
    }

    func loadGame() -> GameData? {
        guard let data = userDefaults.data(forKey: gameDataKey) else {
            #if DEBUG
            print("ℹ️ No saved game found")
            #endif
            return nil
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            let gameData = try decoder.decode(GameData.self, from: data)
            #if DEBUG
            print("✅ Game loaded successfully")
            #endif
            return gameData
        } catch {
            #if DEBUG
            print("❌ Failed to load game: \(error.localizedDescription)")
            #endif
            return nil
        }
    }

    func exportSave() -> String {
        guard let data = userDefaults.data(forKey: gameDataKey) else {
            return "{}"
        }

        // Pretty print JSON for export
        if let jsonObject = try? JSONSerialization.jsonObject(with: data),
           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            return prettyString
        }

        return String(data: data, encoding: .utf8) ?? "{}"
    }

    func importSave(jsonString: String, gameModel: GameModel) -> Bool {
        guard let data = jsonString.data(using: .utf8) else {
            #if DEBUG
            print("❌ Failed to convert string to data")
            #endif
            return false
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            let gameData = try decoder.decode(GameData.self, from: data)

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

            #if DEBUG
            print("✅ Save imported successfully")
            #endif

            return true
        } catch {
            #if DEBUG
            print("❌ Failed to import save: \(error.localizedDescription)")
            #endif
            return false
        }
    }
}
