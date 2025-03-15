//
//  DialgoueFontModifier.swift
//  ForestTori
//
//  Created by Nayeon Kim on 3/15/25.
//

import SwiftUI

struct DialgoueFontModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.black)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 16)
    }
}
