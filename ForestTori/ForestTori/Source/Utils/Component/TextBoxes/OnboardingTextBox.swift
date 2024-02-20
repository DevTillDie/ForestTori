//
//  OnboardingTextBox.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/20/24.
//

import SwiftUI

struct OnboardingTextBox: View {
    let texts: [OnboardingText]
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(texts) { text in
                Text(text.text)
            }
        }
    }
}
