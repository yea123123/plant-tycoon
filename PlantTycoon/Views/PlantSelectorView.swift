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
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        Text("Select a seed to plant")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.top)

                        ForEach(PlantType.allCases, id: \.self) { plantType in
                            VStack(spacing: 12) {
                                HStack {
                                    Text(plantType.rawValue)
                                        .font(.headline)
                                    Spacer()
                                }

                                ForEach(PlantRarity.allCases, id: \.self) { rarity in
                                    let count = gameModel.seedInventory.count(type: plantType, rarity: rarity)

                                    Button(action: {
                                        if gameModel.plantSeed(type: plantType, rarity: rarity, shelfIndex: shelfIndex) {
                                            dismiss()
                                        }
                                    }) {
                                        HStack {
                                            Text(plantType.rawValue)
                                            Text("(\(rarity.rawValue))")
                                                .foregroundColor(rarityColor(rarity))

                                            Spacer()

                                            Text("x\(count)")
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                        .background(count > 0 ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
                                        .cornerRadius(8)
                                    }
                                    .disabled(count == 0)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom)
                }
            }
            .navigationTitle("Plant Seed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func rarityColor(_ rarity: PlantRarity) -> Color {
        switch rarity {
        case .common: return .gray
        case .rare: return .blue
        case .epic: return .purple
        }
    }
}
