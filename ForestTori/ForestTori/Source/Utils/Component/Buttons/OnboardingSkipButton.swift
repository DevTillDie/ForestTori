//
//  SkipButton.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/18/24.
//

import SwiftUI

struct OnboardingSkipButton: View {
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text("Skip")
                Image(systemName: "chevron.right")
            }
            .font(.bodyM)
            .foregroundColor(.brownPrimary)
        }
    }
}
