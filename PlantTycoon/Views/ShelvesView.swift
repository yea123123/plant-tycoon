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
            // Shelf selector with modern design
            if gameModel.shelves.count > 1 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<gameModel.shelves.count, id: \.self) { index in
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedShelfIndex = index
                                }
                            }) {
                                VStack(spacing: 6) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "leaf.fill")
                                            .font(.caption)
                                        Text("Shelf \(index + 1)")
                                            .font(.system(size: 14, weight: .semibold))
                                    }

                                    Text("\(gameModel.shelves[index].plants.count)/\(gameModel.shelves[index].maxCapacity)")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(selectedShelfIndex == index ?
                                              AnyShapeStyle(LinearGradient(colors: [Color(hex: "00f260"), Color(hex: "0575e6")], startPoint: .leading, endPoint: .trailing)) :
                                              AnyShapeStyle(LinearGradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)], startPoint: .leading, endPoint: .trailing)))
                                        .shadow(color: selectedShelfIndex == index ? Color(hex: "00f260").opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
                                )
                                .foregroundColor(.white)
                            }
                            .buttonStyle(ScaleButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 8)
            }

            // Plants grid with modern cards
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(Array(gameModel.shelves[validShelfIndex].plants.enumerated()), id: \.element.id) { index, plant in
                        ModernPlantCard(plant: plant, shelfIndex: validShelfIndex, plantIndex: index)
                    }

                    // Add plant button with modern design
                    if gameModel.shelves[validShelfIndex].hasSpace {
                        Button(action: {
                            showPlantSelector = true
                        }) {
                            VStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(LinearGradient(colors: [Color(hex: "00f260"), Color(hex: "0575e6")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .frame(width: 60, height: 60)
                                        .shadow(color: Color(hex: "00f260").opacity(0.4), radius: 8, x: 0, y: 4)

                                    Image(systemName: "plus")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.white)
                                }

                                Text("Plant Seed")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 220)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
                                            .foregroundStyle(LinearGradient(colors: [Color(hex: "00f260"), Color(hex: "0575e6")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    )
                            )
                        }
                        .buttonStyle(ScaleButtonStyle())
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
            if selectedShelfIndex >= newCount {
                selectedShelfIndex = max(0, newCount - 1)
            }
        }
    }
}

struct ModernPlantCard: View {
    @EnvironmentObject var gameModel: GameModel
    let plant: Plant
    let shelfIndex: Int
    let plantIndex: Int
    @State private var isShaking = false
    @State private var showActions = false

    var body: some View {
        VStack(spacing: 0) {
            // Plant display area
            ZStack {
                // Background gradient based on rarity
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(rarityGradient(plant.rarity))
                    .frame(height: 120)

                VStack(spacing: 8) {
                    // Plant emoji with animation
                    Text(plant.emoji)
                        .font(.system(size: 50))
                        .rotationEffect(.degrees(isShaking ? -5 : 0))
                        .animation(isShaking ? Animation.easeInOut(duration: 0.1).repeatCount(3) : .default, value: isShaking)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)

                    // Growth stage indicator
                    HStack(spacing: 4) {
                        ForEach(0..<5) { i in
                            Circle()
                                .fill(Double(i) < plant.growthStage * 5 ? Color.white : Color.white.opacity(0.3))
                                .frame(width: 6, height: 6)
                        }
                    }
                }
            }

            // Info section
            VStack(spacing: 12) {
                // Plant name and rarity
                VStack(spacing: 4) {
                    Text(plant.type.rawValue)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)

                    Text(plant.rarity.rawValue)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(rarityColor(plant.rarity))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(rarityColor(plant.rarity).opacity(0.2))
                        )
                }

                // Compact stats
                VStack(spacing: 6) {
                    CompactStatBar(icon: "chart.line.uptrend.xyaxis", value: plant.growthStage, color: Color(hex: "0575e6"))
                    CompactStatBar(icon: "heart.fill", value: plant.health / 100, color: Color(hex: "00f260"))
                    CompactStatBar(icon: "sparkles", value: plant.beauty / 100, color: Color(hex: "f093fb"))
                }

                // Action buttons
                HStack(spacing: 8) {
                    CompactActionButton(icon: "drop.fill", enabled: plant.canWater, color: Color(hex: "4facfe")) {
                        gameModel.waterPlant(shelfIndex: shelfIndex, plantIndex: plantIndex)
                        shake()
                    }
                    CompactActionButton(icon: "leaf.fill", enabled: plant.canFertilize, color: Color(hex: "43e97b")) {
                        gameModel.fertilizePlant(shelfIndex: shelfIndex, plantIndex: plantIndex)
                        shake()
                    }
                    CompactActionButton(icon: "scissors", enabled: plant.canPrune, color: Color(hex: "fa709a")) {
                        gameModel.prunePlant(shelfIndex: shelfIndex, plantIndex: plantIndex)
                        shake()
                    }
                }

                // Sell button
                let trendMultiplier = gameModel.marketTrend.priceMultiplier(for: plant.type)
                let finalPrice = Int(Double(plant.sellPrice) * trendMultiplier)

                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        gameModel.sellPlant(shelfIndex: shelfIndex, plantIndex: plantIndex)
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "dollarsign.circle.fill")
                            .font(.system(size: 14))
                        Text("Sell for \(finalPrice)")
                            .font(.system(size: 13, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(
                            colors: plant.beauty >= 80 ?
                                [Color(hex: "00f260"), Color(hex: "0575e6")] :
                                [Color(hex: "f093fb"), Color(hex: "f5576c")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: (plant.beauty >= 80 ? Color(hex: "00f260") : Color(hex: "f5576c")).opacity(0.3), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(ScaleButtonStyle())
            }
            .padding(12)
        }
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.08))
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        )
    }

    private func shake() {
        isShaking = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isShaking = false
        }
    }

    private func rarityColor(_ rarity: PlantRarity) -> Color {
        switch rarity {
        case .common: return Color(hex: "95a5a6")
        case .rare: return Color(hex: "3498db")
        case .epic: return Color(hex: "9b59b6")
        }
    }

    private func rarityGradient(_ rarity: PlantRarity) -> LinearGradient {
        switch rarity {
        case .common:
            return LinearGradient(colors: [Color(hex: "bdc3c7"), Color(hex: "2c3e50")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .rare:
            return LinearGradient(colors: [Color(hex: "4facfe"), Color(hex: "00f2fe")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .epic:
            return LinearGradient(colors: [Color(hex: "a8edea"), Color(hex: "fed6e3")], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

struct CompactStatBar: View {
    let icon: String
    let value: Double
    let color: Color

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 16)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 6)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(value), height: 6)
                }
            }
            .frame(height: 6)

            Text("\(Int(value * 100))%")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 32, alignment: .trailing)
        }
    }
}

struct CompactActionButton: View {
    let icon: String
    let enabled: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(enabled ? .white : .white.opacity(0.3))
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(enabled ? color.opacity(0.8) : Color.white.opacity(0.1))
                        .shadow(color: enabled ? color.opacity(0.3) : .clear, radius: 4, x: 0, y: 2)
                )
        }
        .disabled(!enabled)
        .buttonStyle(ScaleButtonStyle())
    }
}
