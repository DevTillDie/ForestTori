//
//  WriteHistoryViewModel.swift
//  ForestTori
//
//  Created by hyebin on 4/15/24.
//

import SwiftUI

class WriteHistoryViewModel: ObservableObject {
    @Published var todayHistory = "" {
        didSet {
            updateIsCompleteButtonDisable()
        }
    }
    
    @Published var selectedImage: UIImage? {
        didSet {
            updateIsCompleteButtonDisable()
        }
    }
    
    @Published var isCompleteButtonDisable = true

    var plantName = ""
    
    func saveHistory() {
        RealmManager.shared.saveHistory(plantName: plantName, image: selectedImage, text: todayHistory)
    }
    
    private func updateIsCompleteButtonDisable() {
        isCompleteButtonDisable = todayHistory.isEmpty || selectedImage == nil
    }
}
