//
//  HistoryViewModel.swift
//  ForestTori
//
//  Created by hyebin on 4/15/24.
//

import SwiftUI

class HistoryViewModel: ObservableObject {
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
    
    func saveHistory() {
        RealmManager.shared.saveHistory(image: selectedImage, text: todayHistory)
    }
    
    private func updateIsCompleteButtonDisable() {
        isCompleteButtonDisable = todayHistory.isEmpty || selectedImage == nil
    }
}
