//
//  View+.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/18/24.
//

import Foundation
import SwiftUI

// MARK: - onboardingTextBox

extension View {
    @ViewBuilder func onboardingTextBox(texts: [OnboardingText]) -> some View {
        VStack(spacing: 4) {
            ForEach(texts) { text in
                Text(text.text)
            }
        }
    }
}
