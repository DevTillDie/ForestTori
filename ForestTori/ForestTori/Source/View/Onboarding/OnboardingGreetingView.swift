//
//  OnboardingGreetingView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/15/24.
//

import SwiftUI

struct OnboardingGreetingView: View {
    @ObservedObject var onboardingViewModel: OnboardingViewModel
    
    @State var isHidden = true
    @State var textIndex = 0
    
    let doneButtonLabel = "좋아요"
    let imageName = "OnboardingFrezia"
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            onboardingTextBox(texts: onboardingViewModel.onboardingGreetingTexts[textIndex])
                .font(.titleL)
                .foregroundColor(.brownPrimary)
            
            Spacer()
            
            OnboardingDoneButton(action: moveToOnboardingIntroductionView, label: doneButtonLabel)
                .foregroundColor(.yellowTertiary)
                .background {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.brownPrimary)
                }
                .opacity(setHidden(isHidden))
        }
        .padding(20)
        .toolbar {
            OnboardingSkipButton(action: moveToOnboardingSettingView)
                .opacity(setHidden(isHidden))
        }
        .onAppear {
            increaseTextIndex()
        }
    }
}

// MARK: - functions

extension OnboardingGreetingView {
    private func moveToOnboardingIntroductionView() {
        onboardingViewModel.type = .introduction
    }
    
    private func moveToOnboardingSettingView() {
        onboardingViewModel.type = .naming
    }
    
    private func increaseTextIndex() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            withAnimation(.easeInOut(duration: 1)) {
                isHidden = false
                textIndex += 1
            }
        }
    }
}

// MARK: - UI

extension OnboardingGreetingView {
    private func setHidden(_ isHidden: Bool) -> CGFloat {
        return isHidden ? 0 : 1
    }
}

#Preview {
    OnboardingGreetingView(onboardingViewModel: OnboardingViewModel())
}
