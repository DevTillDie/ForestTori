//
//  HistoryViewModel.swift
//  ForestTori
//
//  Created by hyebin on 4/27/24.
//

import Foundation

class HistoryViewModel: ObservableObject {
    @Published var plantHistory = [History]()
    
    func loadHistoryData(plantName: String) {
        plantHistory = RealmManager.shared.loadHistory(plantName: plantName)
    }

    func setBackgroundImage(_ chapter: String) -> String {
        switch chapter {
        case "SpringCharacter":
            return "SpringBackground"
            
        case "SummerCharacter":
            return "SummerBackground"
            
        case "AutumnCharacter":
            return "AutumnBackground"
            
        case "WinterCharacter":
            return "WinterCharacter"
            
        default:
            return "DefaultBackground"
        }
    }
}
