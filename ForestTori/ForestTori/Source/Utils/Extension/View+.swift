//
//  View+.swift
//  ForestTori
//
//  Created by hyebin on 2/17/24.
//

import SwiftUI

// MARK: - View
extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 1 : 0)
    }
}
