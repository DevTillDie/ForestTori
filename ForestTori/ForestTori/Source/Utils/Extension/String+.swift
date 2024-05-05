//
//  String+.swift
//  ForestTori
//
//  Created by hyebin on 5/2/24.
//

import Foundation

extension String {
    func splitChatacter() -> String {
        return self.split(separator: "").joined(separator: "\u{200B}")
    }
}
