//
//  OnboardingCompletionView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/19/24.
//

import SwiftUI

struct OnboardingCompletionView: View {
    @EnvironmentObject var serviceStateViewModel: ServiceStateViewModel
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    
    private let doneButtonLabel = "시작하기"
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Image(.chapterThumbnail1)
                    .resizable()
                    .scaledToFit()
                    .padding(20)
                
                OnboardingTextBox(texts: onboardingViewModel.onboardingCompletionText)
                    .font(.titleL)
                    .foregroundColor(.brownPrimary)
            }
            VStack {
                Spacer()
                
                OnboardingDoneButton(action: { serviceStateViewModel.state = .main
                }, label: doneButtonLabel)
                    .font(.titleL)
                    .foregroundColor(.yellowTertiary)
                    .background {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(.brownPrimary)
                    }
            }
        }
        .padding(20)
    }
}

#Preview {
    OnboardingView()
}
