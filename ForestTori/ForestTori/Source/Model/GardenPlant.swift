//
//  GardenPlant.swift
//  ForestTori
//
//  Created by hyebin on 7/16/24.
//

import Foundation

/// 식물 정보
///
/// - id: 식물의 id
/// - plantName: 식물의 이름
/// - gardenMessage: 정원에 표시될 text
/// - garden3DFile: 정원 배치 식물 3D file 이름
/// - gardenPositionX: 정원 배치 x position 값
/// - gardenPositionY: 정원 배치 y position 값
/// - gardenPositionZ: 정원 배치 z position 값
/// - completeDescription: 정원의 historyView에 나타날 문장
struct GardenPlant: Identifiable, Codable {
    var id: Int
    var plantName: String
    var gardenMessage: String
    var garden3DFile: String
    var gardenPositionX: Float
    var gardenPositionY: Float = 0.5
    var gardenPositionZ: Float
    var completeDescription: String
}
