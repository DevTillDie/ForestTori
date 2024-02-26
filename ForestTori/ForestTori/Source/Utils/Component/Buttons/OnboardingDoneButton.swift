//
//  OnboardingDoneButton.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/18/24.
//

import SwiftUI

struct OnboardingDoneButton: View {
    let action: () -> Void
    let label: String
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(label)
                .font(.titleL)
                .padding()
                .frame(maxWidth: .infinity)
        }
    }
}
