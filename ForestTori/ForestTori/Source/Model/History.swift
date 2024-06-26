//
//  History.swift
//  ForestTori
//
//  Created by hyebin on 4/15/24.
//

import SwiftUI
import RealmSwift

/// Realm에 저장되는 데이터
///
/// - date: 입력 날짜
/// - plantName:  식물 이름
/// - text: 사용자가 작성한 성장일지
/// - imageData: 사용자가 작성한 성장일지 이미지
class History: Object {
    @Persisted var date: String =  ""
    @Persisted var plantName: String = ""
    @Persisted var text: String = ""
    @Persisted var imageData: Data?
}
