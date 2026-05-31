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
                // Player stats card
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(LinearGradient(colors: [Color(hex: "00f260"), Color(hex: "0575e6")], startPoint: .topLeading, endPoint: .bottomTrailing))

                        Text("Player Stats")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)

                        Spacer()
                    }

                    VStack(spacing: 12) {
                        ModernStatRow(icon: "star.fill", label: "Level", value: "\(gameModel.playerLevel)", color: Color(hex: "f093fb"))
                        ModernStatRow(icon: "chart.line.uptrend.xyaxis", label: "Total Sales", value: "$\(gameModel.totalSales)", color: Color(hex: "00f260"))
                        ModernStatRow(icon: "dollarsign.circle.fill", label: "Current Coins", value: "$\(gameModel.coins)", color: Color(hex: "feca57"))
                        ModernStatRow(icon: "leaf.fill", label: "Total Plants", value: "\(totalPlants())", color: Color(hex: "4facfe"))
                        ModernStatRow(icon: "bag.fill", label: "Total Seeds", value: "\(gameModel.seedInventory.totalSeeds())", color: Color(hex: "fa709a"))
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.08))
                        .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
                )

                // Market trend card
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(LinearGradient(colors: [Color(hex: "f093fb"), Color(hex: "f5576c")], startPoint: .topLeading, endPoint: .bottomTrailing))

                        Text("Market Trend")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)

                        Spacer()
                    }

                    HStack(spacing: 16) {
                        // Trending plant
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Trending Now")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white.opacity(0.6))

                            HStack(spacing: 8) {
                                Text(plantEmoji(gameModel.marketTrend.trendingPlant))
                                    .font(.system(size: 40))

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(gameModel.marketTrend.trendingPlant.rawValue)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)

                                    HStack(spacing: 4) {
                                        Image(systemName: "arrow.up.circle.fill")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color(hex: "00f260"))
                                        Text("+50% price")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(Color(hex: "00f260"))
                                    }
                                }
                            }
                        }

                        Spacer()

                        // Time remaining
                        VStack(spacing: 6) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color(hex: "feca57"))

                            Text(timeRemaining())
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "feca57"))

                            Text("remaining")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "feca57").opacity(0.15))
                        )
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.08))
                        .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
                )

                // Employees card
                if !gameModel.employees.isEmpty {
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "person.2.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(LinearGradient(colors: [Color(hex: "4facfe"), Color(hex: "00f2fe")], startPoint: .topLeading, endPoint: .bottomTrailing))

                            Text("Your Team")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)

                            Spacer()
                        }

                        VStack(spacing: 12) {
                            ForEach(gameModel.employees) { employee in
                                HStack(spacing: 12) {
                                    Text(employee.type.emoji)
                                        .font(.system(size: 32))
                                        .frame(width: 50, height: 50)
                                        .background(
                                            Circle()
                                                .fill(Color.white.opacity(0.1))
                                        )

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(employee.type.rawValue)
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(.white)

                                        Text(employee.type.description)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.white.opacity(0.6))
                                    }

                                    Spacer()

                                    HStack(spacing: 4) {
                                        Circle()
                                            .fill(Color(hex: "00f260"))
                                            .frame(width: 8, height: 8)

                                        Text("Active")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(Color(hex: "00f260"))
                                    }
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.05))
                                )
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white.opacity(0.08))
                            .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
                    )
                }

                // Save management card
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "externaldrive.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(LinearGradient(colors: [Color(hex: "a8edea"), Color(hex: "fed6e3")], startPoint: .topLeading, endPoint: .bottomTrailing))

                        Text("Save Management")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)

                        Spacer()
                    }

                    VStack(spacing: 12) {
                        Button(action: {
                            exportedSave = gameModel.exportSave()
                            showExportAlert = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "square.and.arrow.up.fill")
                                    .font(.system(size: 18))

                                Text("Export Save")
                                    .font(.system(size: 16, weight: .semibold))

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            .foregroundColor(.white)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(LinearGradient(colors: [Color(hex: "4facfe"), Color(hex: "00f2fe")], startPoint: .leading, endPoint: .trailing))
                                    .shadow(color: Color(hex: "00f2fe").opacity(0.3), radius: 8, x: 0, y: 4)
                            )
                        }
                        .buttonStyle(ScaleButtonStyle())

                        Button(action: {
                            showImportAlert = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "square.and.arrow.down.fill")
                                    .font(.system(size: 18))

                                Text("Import Save")
                                    .font(.system(size: 16, weight: .semibold))

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            .foregroundColor(.white)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(LinearGradient(colors: [Color(hex: "f093fb"), Color(hex: "f5576c")], startPoint: .leading, endPoint: .trailing))
                                    .shadow(color: Color(hex: "f5576c").opacity(0.3), radius: 8, x: 0, y: 4)
                            )
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.08))
                        .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
                )
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

struct ModernStatRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(color.opacity(0.15))
                )

            Text(label)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.8))

            Spacer()

            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
    }
}
