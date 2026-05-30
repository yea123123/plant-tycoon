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
    }

    var body: some View {
        VStack(spacing: 0) {
            // Category selector
            HStack(spacing: 0) {
                ForEach(ShopCategory.allCases, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                    }) {
                        Text(category.rawValue)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(selectedCategory == category ? .green : .gray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(selectedCategory == category ? Color.green.opacity(0.2) : Color.clear)
                    }
                }
            }
            .background(Color.gray.opacity(0.1))

            // Content
            ScrollView {
                VStack(spacing: 16) {
                    switch selectedCategory {
                    case .seeds:
                        SeedsShopView()
                    case .employees:
                        EmployeesShopView()
                    case .locations:
                        LocationsShopView()
                    }
                }
                .padding()
            }
        }
    }
}

struct SeedsShopView: View {
    @EnvironmentObject var gameModel: GameModel

    var body: some View {
        VStack(spacing: 16) {
            ForEach(PlantType.allCases, id: \.self) { plantType in
                VStack(spacing: 12) {
                    HStack {
                        Text(plantType.rawValue)
                            .font(.headline)
                        Spacer()
                    }

                    ForEach(PlantRarity.allCases, id: \.self) { rarity in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(plantType.rawValue)
                                    Text("(\(rarity.rawValue))")
                                        .foregroundColor(rarityColor(rarity))
                                }
                                .font(.subheadline)

                                Text("Owned: \(gameModel.seedInventory.count(type: plantType, rarity: rarity))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Button(action: {
                                _ = gameModel.buySeeds(type: plantType, rarity: rarity, count: 1)
                            }) {
                                HStack {
                                    Text("Buy")
                                    Text("💰\(rarity.seedPrice)")
                                        .fontWeight(.bold)
                                }
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(gameModel.coins >= rarity.seedPrice ? Color.green : Color.gray)
                                .cornerRadius(8)
                            }
                            .disabled(gameModel.coins < rarity.seedPrice)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
            }
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

struct EmployeesShopView: View {
    @EnvironmentObject var gameModel: GameModel

    var body: some View {
        VStack(spacing: 16) {
            ForEach(EmployeeType.allCases, id: \.self) { employeeType in
                let isHired = gameModel.employees.contains(where: { $0.type == employeeType })

                HStack {
                    Text(employeeType.emoji)
                        .font(.system(size: 40))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(employeeType.rawValue)
                            .font(.headline)
                        Text(employeeType.description)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    if isHired {
                        Text("✓ Hired")
                            .font(.caption)
                            .foregroundColor(.green)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(8)
                    } else {
                        Button(action: {
                            _ = gameModel.hireEmployee(type: employeeType)
                        }) {
                            HStack {
                                Text("Hire")
                                Text("💰\(employeeType.cost)")
                                    .fontWeight(.bold)
                            }
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(gameModel.coins >= employeeType.cost ? Color.green : Color.gray)
                            .cornerRadius(8)
                        }
                        .disabled(gameModel.coins < employeeType.cost)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
            }
        }
    }
}

struct LocationsShopView: View {
    @EnvironmentObject var gameModel: GameModel

    var body: some View {
        VStack(spacing: 16) {
            ForEach(gameModel.locations) { location in
                HStack {
                    Text(location.type.emoji)
                        .font(.system(size: 40))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(location.type.rawValue)
                            .font(.headline)
                        Text(location.type.description)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    if location.unlocked {
                        Text("✓ Unlocked")
                            .font(.caption)
                            .foregroundColor(.green)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(8)
                    } else {
                        Button(action: {
                            _ = gameModel.unlockLocation(type: location.type)
                        }) {
                            HStack {
                                Text("Unlock")
                                Text("💰\(location.type.cost)")
                                    .fontWeight(.bold)
                            }
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(gameModel.coins >= location.type.cost ? Color.green : Color.gray)
                            .cornerRadius(8)
                        }
                        .disabled(gameModel.coins < location.type.cost)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
            }
        }
    }
}
