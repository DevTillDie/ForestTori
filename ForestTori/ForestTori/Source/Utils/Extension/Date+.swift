//
//  Date+.swift
//  ForestTori
//
//  Created by hyebin on 4/18/24.
//

import Foundation

// Date 타입의 Extension으로 format에 따라 문자열로 반환하는 함수를 제공합니다.
extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"

        return dateFormatter.string(from: self)
    }
    
    static func fromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.date(from: dateString)
    }
}
