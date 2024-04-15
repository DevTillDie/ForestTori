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
    
    func saveHistory() {
        RealmManager.shared.saveHistory(image: selectedImage, text: todayHistory)
    }
}
