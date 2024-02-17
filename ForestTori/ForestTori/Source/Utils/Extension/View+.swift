//
//  View+.swift
//  ForestTori
//
//  Created by hyebin on 2/17/24.
//

import SwiftUI

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
