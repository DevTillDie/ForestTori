//
//  String+.swift
//  ForestTori
//
//  Created by hyebin on 5/2/24.
//

import Foundation

extension String {
    func splitCharacter() -> String {
        return self
            .replacingOccurrences(of: "", with: "\u{200B}")
    }
}
