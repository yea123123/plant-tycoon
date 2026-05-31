//
//  PlantTycoonApp.swift
//  PlantTycoon
//
//  Created by Claude
//

import SwiftUI

@main
struct PlantTycoonApp: App {
    @StateObject private var gameModel = GameModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameModel)
                .preferredColorScheme(.dark)
                .task {
                    // Load game after view appears
                    gameModel.loadGame()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    gameModel.saveGame()
                }
        }
    }
}
