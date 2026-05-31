//
//  PlantSelectorView.swift
//  PlantTycoon
//
//  Created by Claude
//

import SwiftUI

struct PlantSelectorView: View {
    @EnvironmentObject var gameModel: GameModel
    @Environment(\.dismiss) var dismiss
    let shelfIndex: Int

    var body: some View {
        NavigationView {
            mainContent
        }
        .preferredColorScheme(.dark)
    }

    private var mainContent: some View {
        ZStack {
            backgroundGradient

            ScrollView {
                contentView
            }
        }
        .navigationTitle("Plant Seed")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
        }
        .toolbarBackground(Color.black.opacity(0.3), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [Color(hex: "0f2027"), Color(hex: "203a43"), Color(hex: "2c5364")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var contentView: some View {
                    VStack(spacing: 20) {
                        // Header info
                        VStack(spacing: 8) {
                            Image(systemName: "leaf.circle.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(LinearGradient(colors: [Color(hex: "00f260"), Color(hex: "0575e6")], startPoint: .topLeading, endPoint: .bottomTrailing))

                            Text("Select a seed to plant")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.top, 20)

                        // Seeds by plant type
                        ForEach(PlantType.allCases, id: \.self) { plantType in
                            VStack(spacing: 12) {
                                // Plant type header
                                HStack(spacing: 12) {
                                    Text(plantEmoji(plantType))
                                        .font(.system(size: 32))

                                    Text(plantType.rawValue)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)

                                    Spacer()

                                    // Total seeds count
                                    let totalCount = PlantRarity.allCases.reduce(0) { $0 + gameModel.seedInventory.count(type: plantType, rarity: $1) }
                                    if totalCount > 0 {
                                        Text("x\(totalCount)")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white.opacity(0.6))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                Capsule()
                                                    .fill(Color.white.opacity(0.1))
                                            )
                                    }
                                }
                                .padding(.horizontal, 4)

                                // Rarity options
                                VStack(spacing: 10) {
                                    ForEach(PlantRarity.allCases, id: \.self) { rarity in
                                        let count = gameModel.seedInventory.count(type: plantType, rarity: rarity)

                                        Button(action: {
                                            if gameModel.plantSeed(type: plantType, rarity: rarity, shelfIndex: shelfIndex) {
                                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                    dismiss()
                                                }
                                            }
                                        }) {
                                            HStack(spacing: 12) {
                                                // Plant preview
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(rarityGradient(rarity))
                                                        .frame(width: 60, height: 60)
                                                        .shadow(color: rarityColor(rarity).opacity(0.3), radius: 6, x: 0, y: 3)

                                                    Text(plantEmoji(plantType))
                                                        .font(.system(size: 30))
                                                }

                                                VStack(alignment: .leading, spacing: 4) {
                                                    HStack(spacing: 6) {
                                                        Text(plantType.rawValue)
                                                            .font(.system(size: 16, weight: .bold))
                                                            .foregroundColor(.white)

                                                        Text("(\(rarity.rawValue))")
                                                            .font(.system(size: 14, weight: .semibold))
                                                            .foregroundColor(rarityColor(rarity))
                                                    }

                                                    HStack(spacing: 8) {
                                                        HStack(spacing: 4) {
                                                            Image(systemName: "bag.fill")
                                                                .font(.system(size: 11))
                                                            Text("x\(count)")
                                                                .font(.system(size: 13, weight: .semibold))
                                                        }
                                                        .foregroundColor(count > 0 ? .white.opacity(0.8) : .white.opacity(0.4))

                                                        if count > 0 {
                                                            HStack(spacing: 4) {
                                                                Image(systemName: "arrow.right.circle.fill")
                                                                    .font(.system(size: 11))
                                                                Text("Tap to plant")
                                                                    .font(.system(size: 11, weight: .medium))
                                                            }
                                                            .foregroundColor(Color(hex: "00f260"))
                                                        } else {
                                                            HStack(spacing: 4) {
                                                                Image(systemName: "cart.fill")
                                                                    .font(.system(size: 11))
                                                                Text("Buy in shop")
                                                                    .font(.system(size: 11, weight: .medium))
                                                            }
                                                            .foregroundColor(.white.opacity(0.5))
                                                        }
                                                    }
                                                }

                                                Spacer()

                                                // Status indicator
                                                if count > 0 {
                                                    Image(systemName: "chevron.right")
                                                        .font(.system(size: 16, weight: .semibold))
                                                        .foregroundColor(Color(hex: "00f260"))
                                                } else {
                                                    Image(systemName: "lock.fill")
                                                        .font(.system(size: 16))
                                                        .foregroundColor(.white.opacity(0.3))
                                                }
                                            }
                                            .padding(12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(count > 0 ? Color.white.opacity(0.1) : Color.white.opacity(0.05))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 16)
                                                            .stroke(count > 0 ? rarityColor(rarity).opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1)
                                                    )
                                            )
                                        }
                                        .disabled(count == 0)
                                        .buttonStyle(ScaleButtonStyle())
                                    }
                                }
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.05))
                                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                            )
                        }
                    }
                    .padding()
                    .padding(.bottom, 20)
                }
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
