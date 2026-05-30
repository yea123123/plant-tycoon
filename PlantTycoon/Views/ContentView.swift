//
//  ContentView.swift
//  PlantTycoon
//
//  Created by Claude
//

import SwiftUI

enum Tab {
    case shelves
    case shop
    case stats
}

struct ContentView: View {
    @EnvironmentObject var gameModel: GameModel
    @State private var selectedTab: Tab = .shelves

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Plant Tycoon")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        Text("Level \(gameModel.playerLevel)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Text("💰")
                            Text("\(gameModel.coins)")
                                .font(.headline)
                                .foregroundColor(.yellow)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))

                // Content
                Group {
                    switch selectedTab {
                    case .shelves:
                        ShelvesView()
                    case .shop:
                        ShopView()
                    case .stats:
                        StatsView()
                    }
                }

                // Tab Bar
                HStack(spacing: 0) {
                    TabButton(icon: "🪴", title: "Shelves", isSelected: selectedTab == .shelves) {
                        selectedTab = .shelves
                    }
                    TabButton(icon: "🛒", title: "Shop", isSelected: selectedTab == .shop) {
                        selectedTab = .shop
                    }
                    TabButton(icon: "📊", title: "Stats", isSelected: selectedTab == .stats) {
                        selectedTab = .stats
                    }
                }
                .background(Color.gray.opacity(0.1))
            }
        }
    }
}

struct TabButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(icon)
                    .font(.title2)
                Text(title)
                    .font(.caption)
                    .foregroundColor(isSelected ? .green : .gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color.green.opacity(0.2) : Color.clear)
        }
    }
}
