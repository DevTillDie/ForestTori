//
//  SkipButton.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/18/24.
//

import SwiftUI

struct OnboardingSkipButton: View {
    let action: () -> Void
    private let skipLabel = "Skip"
    private let skipSymbolLabel = "chevron.right"
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(skipLabel)
                Image(systemName: skipSymbolLabel)
            }
            .font(.bodyM)
            .foregroundColor(.brownPrimary)
        }
    }
}
