//
//  EndingView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 4/23/24.
//

import SwiftUI

struct EndingView: View {
    @EnvironmentObject var gameManager: GameManager
    
    @AppStorage("_isEpliogueShowed") var isEpliogueShowed = false
    
    var body: some View {
        if !isEpliogueShowed {
            EpliogueView(isEpilogueShowed: $isEpliogueShowed)
                .environmentObject(gameManager)
        } else {
            GardenView()
                .environmentObject(gameManager)
        }
    }
}

#Preview {
    EndingView()
        .environmentObject(GameManager())
}
