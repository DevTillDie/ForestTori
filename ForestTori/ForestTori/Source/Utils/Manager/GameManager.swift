//
//  GameManager.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/6/24.
//

import SwiftUI

/// 게임 진행을 관리하는 클래스
///
/// - user: 사용자 정보 모델
/// - dataManager: 게임 데이터를 관리하는 클래스
/// - isSelectPlant: 식물 선택 여부
class GameManager: ObservableObject {
    @EnvironmentObject var serviceStateViewModel: ServiceStateViewModel
    
    @Published var plantPlayStatus: [Bool] = UserDefaults.standard.array(forKey: "plantPlayStatus") as? [Bool] ?? [true, false, false]
    @Published var isPlantSelected: [Bool] = UserDefaults.standard.array(forKey: "isPlantSelected") as? [Bool] ?? [false, false, false]
    @Published var user = User()
    @Published var chapter: Chapter
    @AppStorage("isSelectPlant") var isSelectPlant = false
    
    private let dataManager = DataManager()
    
    init() {
        // 진행 중인 정보를 유지하기 위해 UserDefault에 저장
        if let userData = UserDefaults.standard.data(forKey: "_userData"),
           let decodeData = try? JSONDecoder().decode(User.self, from: userData) {
            self.user = decodeData
        }
        
        if let chapterData = UserDefaults.standard.data(forKey: "_chapterData"),
           let decodeData = try? JSONDecoder().decode(Chapter.self, from: chapterData) {
            self.chapter = decodeData
        } else {
            chapter = dataManager.chapters[0]
            saveChapterDataToUserDefaults()
        }
    }
    
    /// 새로운 스토리 시작
    func startNewGame() {
        isSelectPlant = false
        
        saveUserDataToUserDefaults()
    }
    
    /// 식물 선택
    ///
    /// - Parameter plant: 사용자가 식물 선택 화면에서 선택한 식물 이름
    func selectPlant(plant: Plant) {
        user.selectedPlant = plant
        isSelectPlant = true
        
        saveUserDataToUserDefaults()
    }
    
    /// 미션 완료 레벨업 및 챕터 진행 체크
    ///
    /// 미션 완료 후 호출되어 사용자의 레벌업 및 챕터 진행 상태를 확인합니다
    func completeMission() {
        if let plant = user.selectedPlant {
            if let data = dataManager.gardenPlants.first(where: {
                $0.id == plant.id
            }) {
                user.completedPlants[user.chapterProgress, default: []].append(data)
            }
        }
        
        user.selectedPlant = nil
    
        user.chapterProgress += 1
        
        if user.chapterProgress < 5 {
            chapter = dataManager.chapters[user.chapterProgress - 1]
        }
        
        saveUserDataToUserDefaults()
        saveChapterDataToUserDefaults()
    }
    
    /// 사용자 모델 데이터를 userDefaults에 저장
    private func saveUserDataToUserDefaults() {
        do {
            let encodedData = try JSONEncoder().encode(user)
            UserDefaults.standard.set(encodedData, forKey: "_userData")
        } catch {
            print("Error encoding user data: \(error)")
        }
    }
    
    /// 챕터 모델 데이터를 userDefaults에 저장
    private func saveChapterDataToUserDefaults() {
        do {
            let encodedData = try JSONEncoder().encode(chapter)
            UserDefaults.standard.set(encodedData, forKey: "_chapterData")
        } catch {
            print("Error encoding chapter data: \(error)")
        }
    }
}
