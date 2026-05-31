//
//  ShelvesView.swift
//  PlantTycoon
//
//  Created by Claude
//

import SwiftUI

struct ShelvesView: View {
    @EnvironmentObject var gameModel: GameModel
    @State private var selectedShelfIndex = 0
    @State private var showPlantSelector = false

    var body: some View {
        // Ensure selectedShelfIndex is valid
        let validShelfIndex = min(selectedShelfIndex, max(0, gameModel.shelves.count - 1))

        VStack(spacing: 16) {
            // Shelf selector
            if gameModel.shelves.count > 1 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<gameModel.shelves.count, id: \.self) { index in
                            Button(action: {
                                selectedShelfIndex = index
                            }) {
                                VStack(spacing: 4) {
                                    Text("Shelf \(index + 1)")
                                        .font(.caption)
                                    Text("\(gameModel.shelves[index].plants.count)/6")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedShelfIndex == index ? Color.green.opacity(0.3) : Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 8)
            }

            // Plants grid
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(Array(gameModel.shelves[validShelfIndex].plants.enumerated()), id: \.element.id) { index, plant in
                        PlantCardView(plant: plant, shelfIndex: validShelfIndex, plantIndex: index)
                    }

                    // Add plant button
                    if gameModel.shelves[validShelfIndex].hasSpace {
                        Button(action: {
                            showPlantSelector = true
                        }) {
                            VStack(spacing: 8) {
                                Text("➕")
                                    .font(.system(size: 40))
                                Text("Plant Seed")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.green.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [5]))
                            )
                        }
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $showPlantSelector) {
            PlantSelectorView(shelfIndex: validShelfIndex)
                .environmentObject(gameModel)
        }
        .onChange(of: gameModel.shelves.count) { newCount in
            // Reset selectedShelfIndex if it's out of bounds
            if selectedShelfIndex >= newCount {
                selectedShelfIndex = max(0, newCount - 1)
            }
        }
    }
}

struct PlantCardView: View {
    @EnvironmentObject var gameModel: GameModel
    let plant: Plant
    let shelfIndex: Int
    let plantIndex: Int
    @State private var isShaking = false

    var body: some View {
        VStack(spacing: 8) {
            // Plant emoji
            Text(plant.emoji)
                .font(.system(size: 50))
                .rotationEffect(.degrees(isShaking ? -5 : 0))
                .animation(isShaking ? Animation.easeInOut(duration: 0.1).repeatCount(3) : .default, value: isShaking)

            // Plant info
            VStack(spacing: 4) {
                Text(plant.type.rawValue)
                    .font(.caption)
                    .fontWeight(.semibold)
                Text(plant.rarity.rawValue)
                    .font(.caption2)
                    .foregroundColor(rarityColor(plant.rarity))
            }

            // Stats
            VStack(spacing: 4) {
                StatBar(label: "Growth", value: plant.growthStage, color: .blue)
                StatBar(label: "Health", value: plant.health / 100, color: .green)
                StatBar(label: "Beauty", value: plant.beauty / 100, color: .pink)
            }

            // Actions
            HStack(spacing: 8) {
                ActionButton(icon: "💧", enabled: plant.canWater) {
                    gameModel.waterPlant(shelfIndex: shelfIndex, plantIndex: plantIndex)
                    shake()
                }
                ActionButton(icon: "🌱", enabled: plant.canFertilize) {
                    gameModel.fertilizePlant(shelfIndex: shelfIndex, plantIndex: plantIndex)
                    shake()
                }
                ActionButton(icon: "✂️", enabled: plant.canPrune) {
                    gameModel.prunePlant(shelfIndex: shelfIndex, plantIndex: plantIndex)
                    shake()
                }
            }

            // Sell button
            let trendMultiplier = gameModel.marketTrend.priceMultiplier(for: plant.type)
            let finalPrice = Int(Double(plant.sellPrice) * trendMultiplier)

            Button(action: {
                gameModel.sellPlant(shelfIndex: shelfIndex, plantIndex: plantIndex)
            }) {
                HStack {
                    Text("Sell")
                    Text("💰\(finalPrice)")
                        .fontWeight(.bold)
                }
                .font(.caption)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .background(plant.beauty >= 80 ? Color.green : Color.orange)
                .cornerRadius(6)
            }
        }
        .padding(12)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }

    private func shake() {
        isShaking = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isShaking = false
        }
    }

    private func rarityColor(_ rarity: PlantRarity) -> Color {
        switch rarity {
        case .common: return .gray
        case .rare: return .blue
        case .epic: return .purple
        }
    }
}

struct StatBar: View {
    let label: String
    let value: Double
    let color: Color

    var body: some View {
        HStack(spacing: 4) {
            Text(label)
                .font(.caption2)
                .foregroundColor(.gray)
                .frame(width: 50, alignment: .leading)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 4)

                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(value), height: 4)
                }
            }
            .frame(height: 4)

            Text("\(Int(value * 100))%")
                .font(.caption2)
                .foregroundColor(.gray)
                .frame(width: 30, alignment: .trailing)
        }
    }
}

struct ActionButton: View {
    let icon: String
    let enabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(icon)
                .font(.title3)
                .frame(width: 36, height: 36)
                .background(enabled ? Color.green.opacity(0.3) : Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
        .disabled(!enabled)
        .opacity(enabled ? 1.0 : 0.5)
    }
}
