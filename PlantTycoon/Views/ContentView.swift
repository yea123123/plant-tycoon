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
        // Ensure shelves exist before rendering
        if gameModel.shelves.isEmpty {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "1a1a2e"), Color(hex: "16213e")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                        .scaleEffect(1.5)

                    Text("Loading Plant Tycoon...")
                        .font(.headline)
                        .foregroundColor(.green)
                }
            }
        } else {
            mainContent
        }
    }

    private var mainContent: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(
                colors: [Color(hex: "0f2027"), Color(hex: "203a43"), Color(hex: "2c5364")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Enhanced Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("🌿 Plant Tycoon")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "00f260"), Color(hex: "0575e6")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                        HStack(spacing: 8) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.caption)
                            Text("Level \(gameModel.playerLevel)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }

                    Spacer()

                    // Coins display with animation
                    HStack(spacing: 12) {
                        HStack(spacing: 6) {
                            Text("💰")
                                .font(.title3)
                            Text("\(gameModel.coins)")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.yellow)
                                .contentTransition(.numericText())
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.black.opacity(0.3))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
                .padding()
                .background(
                    Color.black.opacity(0.2)
                        .blur(radius: 10)
                )

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

                // Modern Tab Bar
                HStack(spacing: 0) {
                    ModernTabButton(
                        icon: "leaf.fill",
                        title: "Garden",
                        isSelected: selectedTab == .shelves
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = .shelves
                        }
                    }

                    ModernTabButton(
                        icon: "cart.fill",
                        title: "Shop",
                        isSelected: selectedTab == .shop
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = .shop
                        }
                    }

                    ModernTabButton(
                        icon: "chart.bar.fill",
                        title: "Stats",
                        isSelected: selectedTab == .stats
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = .stats
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 12)
                .background(
                    Color.black.opacity(0.3)
                        .blur(radius: 10)
                )
            }
        }
    }
}

struct ModernTabButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(isSelected ? Color(hex: "00f260") : .white.opacity(0.5))

                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(isSelected ? Color(hex: "00f260") : .white.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color(hex: "00f260").opacity(0.15) : Color.clear)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// Color extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
