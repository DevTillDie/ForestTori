//
//  Plant.swift
//  ForestTori
//
//  Created by Nayeon Kim on 1/25/24.
//

import Foundation

/// 식물 정보
///
/// - id: 식물의 id
/// - characterName: 식물의 이름
/// - characterImage: 식물의 이미지
/// - characterDescription: 식물 소개
/// - mainQuest: 식물 메인 미션
/// - missions: 해당 식물의 미션 목록
/// - characterFileName: 식물 Dialogue file 이름
/// - character3DFiles: 식물 3D file 이름
/// - totalDay: 식물의 성장 완료에 필요한 총 일수
struct Plant: Identifiable, Codable {
    var id: Int
    var characterName: String
    var characterImage: String
    var characterDescription: String
    var mainQuest: String
    var missions: [Mission]
    var characterFileName: String
    var character3DFiles: [String]
    var totalDay: Int
}
