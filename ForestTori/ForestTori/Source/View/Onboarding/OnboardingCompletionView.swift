//
//  OnboardingCompletionView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/19/24.
//

import SwiftUI

struct OnboardingCompletionView: View {
    @ObservedObject var onboardingViewModel: OnboardingViewModel
    
    let imageName = "ChapterThumbnail1"
    let doneButtonLabel = "시작하기"
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(20)
            
            onboardingTextBox(texts: onboardingViewModel.onboardingCompletionText)
                .font(.titleL)
                .foregroundColor(.brownPrimary)
            
            Spacer()
            
            OnboardingDoneButton(action: completeOnboarding, label: doneButtonLabel)
                .font(.titleL)
                .foregroundColor(.yellowTertiary)
                .background {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.brownPrimary)
                }
        }
        .padding(20)
    }
}

extension OnboardingCompletionView {
    private func completeOnboarding() {
        onboardingViewModel.isFirstLaunching = false
    }
}

#Preview {
    OnboardingCompletionView(onboardingViewModel: OnboardingViewModel())
}
