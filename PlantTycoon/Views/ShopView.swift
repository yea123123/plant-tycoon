//
//  ShopView.swift
//  PlantTycoon
//
//  Created by Claude
//

import SwiftUI

struct ShopView: View {
    @EnvironmentObject var gameModel: GameModel
    @State private var selectedCategory: ShopCategory = .seeds

    enum ShopCategory: String, CaseIterable {
        case seeds = "Seeds"
        case employees = "Employees"
        case locations = "Locations"

        var icon: String {
            switch self {
            case .seeds: return "leaf.fill"
            case .employees: return "person.2.fill"
            case .locations: return "building.2.fill"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Modern category selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(ShopCategory.allCases, id: \.self) { category in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedCategory = category
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: category.icon)
                                    .font(.system(size: 16, weight: .semibold))

                                Text(category.rawValue)
                                    .font(.system(size: 15, weight: .semibold))
                            }
                            .foregroundColor(selectedCategory == category ? .white : .white.opacity(0.6))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(selectedCategory == category ?
                                          LinearGradient(colors: [Color(hex: "00f260"), Color(hex: "0575e6")], startPoint: .leading, endPoint: .trailing) :
                                          Color.white.opacity(0.1))
                                    .shadow(color: selectedCategory == category ? Color(hex: "00f260").opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
                            )
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }

            // Content
            ScrollView {
                VStack(spacing: 16) {
                    switch selectedCategory {
                    case .seeds:
                        ModernSeedsShopView()
                    case .employees:
                        ModernEmployeesShopView()
                    case .locations:
                        ModernLocationsShopView()
                    }
                }
                .padding()
            }
        }
    }
}

struct ModernSeedsShopView: View {
    @EnvironmentObject var gameModel: GameModel

    var body: some View {
        VStack(spacing: 16) {
            ForEach(PlantType.allCases, id: \.self) { plantType in
                VStack(spacing: 12) {
                    // Plant type header
                    HStack {
                        Text(plantEmoji(plantType))
                            .font(.title2)
                        Text(plantType.rawValue)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal, 4)

                    // Rarity options
                    ForEach(PlantRarity.allCases, id: \.self) { rarity in
                        let count = gameModel.seedInventory.count(type: plantType, rarity: rarity)
                        let canAfford = gameModel.coins >= rarity.seedPrice

                        Button(action: {
                            if gameModel.buySeeds(type: plantType, rarity: rarity, count: 1) {
                                // Success feedback
                            }
                        }) {
                            HStack(spacing: 12) {
                                // Rarity badge
                                VStack(spacing: 4) {
                                    Text(rarity.rawValue)
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(rarityColor(rarity))

                                    Text("x\(count)")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                .frame(width: 70)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(rarityColor(rarity).opacity(0.15))
                                )

                                Spacer()

                                // Price and buy button
                                HStack(spacing: 12) {
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text("Price")
                                            .font(.system(size: 10, weight: .medium))
                                            .foregroundColor(.white.opacity(0.5))

                                        HStack(spacing: 4) {
                                            Image(systemName: "dollarsign.circle.fill")
                                                .font(.system(size: 12))
                                                .foregroundColor(.yellow)
                                            Text("\(rarity.seedPrice)")
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(.yellow)
                                        }
                                    }

                                    Image(systemName: canAfford ? "cart.fill.badge.plus" : "lock.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(width: 44, height: 44)
                                        .background(
                                            Circle()
                                                .fill(canAfford ?
                                                      LinearGradient(colors: [Color(hex: "00f260"), Color(hex: "0575e6")], startPoint: .topLeading, endPoint: .bottomTrailing) :
                                                      LinearGradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                .shadow(color: canAfford ? Color(hex: "00f260").opacity(0.3) : .clear, radius: 6, x: 0, y: 3)
                                        )
                                }
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.08))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(canAfford ? Color(hex: "00f260").opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                        }
                        .disabled(!canAfford)
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
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

struct ModernEmployeesShopView: View {
    @EnvironmentObject var gameModel: GameModel

    var body: some View {
        VStack(spacing: 16) {
            ForEach(EmployeeType.allCases, id: \.self) { employeeType in
                let isHired = gameModel.employees.contains(where: { $0.type == employeeType })
                let canAfford = gameModel.coins >= employeeType.cost

                Button(action: {
                    _ = gameModel.hireEmployee(type: employeeType)
                }) {
                    HStack(spacing: 16) {
                        // Employee icon
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [Color(hex: "f093fb"), Color(hex: "f5576c")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 70, height: 70)
                                .shadow(color: Color(hex: "f5576c").opacity(0.3), radius: 8, x: 0, y: 4)

                            Text(employeeType.emoji)
                                .font(.system(size: 36))
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text(employeeType.rawValue)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)

                            Text(employeeType.description)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .lineLimit(2)

                            if isHired {
                                HStack(spacing: 4) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(hex: "00f260"))
                                    Text("Hired")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(Color(hex: "00f260"))
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(Color(hex: "00f260").opacity(0.2))
                                )
                            } else {
                                HStack(spacing: 4) {
                                    Image(systemName: "dollarsign.circle.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.yellow)
                                    Text("\(employeeType.cost)")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.yellow)
                                }
                            }
                        }

                        Spacer()

                        if !isHired {
                            Image(systemName: canAfford ? "person.badge.plus.fill" : "lock.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(
                                    Circle()
                                        .fill(canAfford ?
                                              LinearGradient(colors: [Color(hex: "00f260"), Color(hex: "0575e6")], startPoint: .topLeading, endPoint: .bottomTrailing) :
                                              LinearGradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .shadow(color: canAfford ? Color(hex: "00f260").opacity(0.3) : .clear, radius: 6, x: 0, y: 3)
                                )
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(isHired ? Color(hex: "00f260").opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    )
                }
                .disabled(isHired || !canAfford)
                .buttonStyle(ScaleButtonStyle())
            }
        }
    }
}

struct ModernLocationsShopView: View {
    @EnvironmentObject var gameModel: GameModel

    var body: some View {
        VStack(spacing: 16) {
            ForEach(gameModel.locations) { location in
                let canAfford = gameModel.coins >= location.type.cost

                Button(action: {
                    _ = gameModel.unlockLocation(type: location.type)
                }) {
                    HStack(spacing: 16) {
                        // Location icon
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(LinearGradient(colors: [Color(hex: "4facfe"), Color(hex: "00f2fe")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 70, height: 70)
                                .shadow(color: Color(hex: "00f2fe").opacity(0.3), radius: 8, x: 0, y: 4)

                            Text(location.type.emoji)
                                .font(.system(size: 36))
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text(location.type.rawValue)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)

                            Text(location.type.description)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .lineLimit(2)

                            if location.unlocked {
                                HStack(spacing: 4) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(hex: "00f260"))
                                    Text("Unlocked")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(Color(hex: "00f260"))
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(Color(hex: "00f260").opacity(0.2))
                                )
                            } else {
                                HStack(spacing: 4) {
                                    Image(systemName: "dollarsign.circle.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.yellow)
                                    Text("\(location.type.cost)")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.yellow)
                                }
                            }
                        }

                        Spacer()

                        if !location.unlocked {
                            Image(systemName: canAfford ? "lock.open.fill" : "lock.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(
                                    Circle()
                                        .fill(canAfford ?
                                              LinearGradient(colors: [Color(hex: "00f260"), Color(hex: "0575e6")], startPoint: .topLeading, endPoint: .bottomTrailing) :
                                              LinearGradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .shadow(color: canAfford ? Color(hex: "00f260").opacity(0.3) : .clear, radius: 6, x: 0, y: 3)
                                )
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(location.unlocked ? Color(hex: "00f260").opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    )
                }
                .disabled(location.unlocked || !canAfford)
                .buttonStyle(ScaleButtonStyle())
            }
        }
    }
}
