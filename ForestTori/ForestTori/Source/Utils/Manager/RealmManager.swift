//
//  RealmManager.swift
//  ForestTori
//
//  Created by hyebin on 4/15/24.
//

import SwiftUI
import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    private let realm: Realm
        
    private init() {
        do {
            self.realm = try Realm()
        } catch {
            fatalError("Error initializing Realm: \(error)")
        }
    }
    
    func saveHistory(plantName: String, image: UIImage?, text: String) {
        let newHistory = History()
        newHistory.text = text
        
        if let imageData = image?.jpegData(compressionQuality: 0.5) {
            newHistory.imageData = imageData
        }
        
        newHistory.date = Date().toString()
        newHistory.plantName = plantName
        
        do {
            try realm.write {
                realm.add(newHistory)
            }
        } catch {
            fatalError("Error saving history to Realm: \(error)")
        }
    }
    
    func loadHistory() -> [History] {
        let histories = realm.objects(History.self)
        return Array(histories)
    }
}
