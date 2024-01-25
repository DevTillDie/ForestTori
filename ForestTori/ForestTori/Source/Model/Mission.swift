//
//  Mission.swift
//  ForestTori
//
//  Created by Nayeon Kim on 1/25/24.
//

import Foundation

/// 미션 정보
///
/// - day: 미션 일차
/// - content: 미션 내용
/// - isCopmleted: 미션 완료 여부
struct Mission {
    var day: Int
    var content: String
    var isCompleted: Bool = false
}
