//
//  HistoryViewModel.swift
//  ForestTori
//
//  Created by hyebin on 4/15/24.
//

import SwiftUI

class HistoryViewModel: ObservableObject {
    @Published var todayHistory = ""
    @Published var selectedImage: UIImage?
    
    var plantName = ""
    
    func saveHistory() {
        RealmManager.shared.saveHistory(plantName: plantName, image: selectedImage, text: todayHistory)
    }
}