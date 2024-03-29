//
//  GameManager.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/6/24.
//

import Foundation

/// 게임 진행을 관리하는 클래스
///
/// - user: 사용자 정보 모델
/// - dataManager: 게임 데이터를 관리하는 클래스
class GameManager: ObservableObject {
    @Published var user = User()
    @Published var plants = [Plant]()
    @Published var isSelectPlant = false
    
    private let dataManager = DataManager()
    
    init() {
        plants = dataManager.chapters[user.chapterProgress-1].chapterPlants
    }
    
    /// 게임 시작
    func startNewGame() {
        user.selectedPlant = nil
        isSelectPlant = false
    }
    
    /// 식물 선택
    ///
    /// - Parameter plant: 사용자가 식물 선택 화면에서 선택한 식물 이름
    func selectPlant(plant: Plant) {
        user.selectedPlant = plant
        isSelectPlant = true
    }
    
    /// 미션 완료
    func completeMission() {
        if let plant = user.selectedPlant {
            user.completedPlants.append(plant)
            user.selectedPlant = nil
        }
        
        isSelectPlant = false
        
        checkLevelUpAndChapterProgress()
    }
    
    /// 레벨업 및 챕터 진행 체크
    ///
    /// 미션 완료 후 호출되어 사용자의 레벌업 및 챕터 진행 상태를 확인합니다
    func checkLevelUpAndChapterProgress() {
        // TODO: 레벨업 및 챕터 진행 체크 코드 추가
        user.chapterProgress += 1
        
        if user.chapterProgress == 5 {
            // TODO: 엔딩
        }
        
        plants = dataManager.chapters[user.chapterProgress-1].chapterPlants
    }
}
