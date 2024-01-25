//
//  Plant.swift
//  ForestTori
//
//  Created by Nayeon Kim on 1/25/24.
//

import Foundation

/// 식물 정보
///
/// - characterName: 식물의 이름
/// - characterDescription: 식물 소개
/// - characterLevel: 식물의 레벨
/// - mainQuest: 식물 메인 미션
/// - missions: 해당 식물의 미션 목록
/// - progressDay: 식물의 현재 진행 일차
/// - totalDay: 식물의 성장 완료에 필요한 총 일수
struct Plant {
    var characterName: String
    var characterDescription: String
    var characterLevel = 1
    var mainQuest: String
    var missions: [Mission]
    var progressDay: Int = 1
    var totalDay: Int
}
