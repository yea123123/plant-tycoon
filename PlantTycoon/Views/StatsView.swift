//
//  StatsView.swift
//  PlantTycoon
//
//  Created by Claude
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var gameModel: GameModel
    @State private var showExportAlert = false
    @State private var showImportAlert = false
    @State private var importText = ""
    @State private var exportedSave = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Player stats
                VStack(spacing: 16) {
                    Text("Player Stats")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)

                    StatRow(label: "Level", value: "\(gameModel.playerLevel)")
                    StatRow(label: "Total Sales", value: "💰\(gameModel.totalSales)")
                    StatRow(label: "Current Coins", value: "💰\(gameModel.coins)")
                    StatRow(label: "Total Plants", value: "\(totalPlants())")
                    StatRow(label: "Total Seeds", value: "\(gameModel.seedInventory.totalSeeds())")
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)

                // Market trend
                VStack(spacing: 16) {
                    Text("Market Trend")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)

                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Trending Plant")
                                .font(.caption)
                                .foregroundColor(.gray)
                            HStack {
                                Text(plantEmoji(gameModel.marketTrend.trendingPlant))
                                    .font(.title)
                                Text(gameModel.marketTrend.trendingPlant.rawValue)
                                    .font(.headline)
                            }
                            Text("+50% sell price")
                                .font(.caption)
                                .foregroundColor(.green)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Time left")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(timeRemaining())
                                .font(.headline)
                                .foregroundColor(.orange)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)

                // Employees
                if !gameModel.employees.isEmpty {
                    VStack(spacing: 16) {
                        Text("Employees")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)

                        ForEach(gameModel.employees) { employee in
                            HStack {
                                Text(employee.type.emoji)
                                    .font(.title2)
                                Text(employee.type.rawValue)
                                    .font(.subheadline)
                                Spacer()
                                Text("✓ Active")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                }

                // Save management
                VStack(spacing: 16) {
                    Text("Save Management")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)

                    Button(action: {
                        exportedSave = gameModel.exportSave()
                        showExportAlert = true
                    }) {
                        HStack {
                            Text("📤")
                            Text("Export Save")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.3))
                        .cornerRadius(8)
                    }

                    Button(action: {
                        showImportAlert = true
                    }) {
                        HStack {
                            Text("📥")
                            Text("Import Save")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple.opacity(0.3))
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
            }
            .padding()
        }
        .alert("Export Save", isPresented: $showExportAlert) {
            Button("Copy to Clipboard") {
                UIPasteboard.general.string = exportedSave
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Save data copied! You can paste it to a file for backup.")
        }
        .alert("Import Save", isPresented: $showImportAlert) {
            TextField("Paste save data", text: $importText)
            Button("Import") {
                if gameModel.importSave(jsonString: importText) {
                    importText = ""
                }
            }
            Button("Cancel", role: .cancel) {
                importText = ""
            }
        } message: {
            Text("Paste your save data to restore your game.")
        }
    }

    private func totalPlants() -> Int {
        return gameModel.shelves.reduce(0) { $0 + $1.plants.count }
    }

    private func timeRemaining() -> String {
        let remaining = gameModel.marketTrend.duration - Date().timeIntervalSince(gameModel.marketTrend.startDate)
        if remaining <= 0 {
            return "Refreshing..."
        }
        let minutes = Int(remaining) / 60
        let seconds = Int(remaining) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func plantEmoji(_ type: PlantType) -> String {
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
}

struct StatRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
    }
}
