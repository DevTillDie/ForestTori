//
//  Dialogue.swift
//  ForestTori
//
//  Created by hyebin on 2/17/24.
//

import Foundation

/// 캐릭터 대사
///
/// - id:  고유 식별자
/// - day: 미션 일차
/// - type: 대사 유형
///     - Opening: 미션 시작 안내 대사
///     - End: 미션 종료 안내 대사
/// - lines: 대사
struct Dialogue: Codable {
    var id: Int
    var day: Int
    var type: String
    var lines: [String]
}
