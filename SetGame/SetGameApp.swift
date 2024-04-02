//
//  SetGameApp.swift
//  SetGame
//
//  Created by KELLIE LAFLIN on 3/26/24.
//

import SwiftUI

@main
struct SetGameApp: App {
    @StateObject var game = SetGameViewModel()
    
    var body: some Scene {
        WindowGroup {
            SetGameMainView(game: game)
        }
    }
}
