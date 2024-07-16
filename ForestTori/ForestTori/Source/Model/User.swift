//
//  User.swift
//  ForestTori
//
//  Created by Nayeon Kim on 1/25/24.
//

import SwiftUI

/// 사용자 정보
///
/// - selectedPlant: 사용자가 선택한 식물
/// - chapterProgress: 사용자가 현재 진행 중인 챕터 번호
/// - completedPlants: 성장이 완료된 식물 목록
struct User: Codable {
    var selectedPlant: Plant?
    var chapterProgress = 1
    var completedPlants: [Int: [GardenPlant]] = [:]
}
