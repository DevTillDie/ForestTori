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
        print(plantHistory)
    }
}
