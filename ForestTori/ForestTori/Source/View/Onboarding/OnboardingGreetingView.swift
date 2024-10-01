//
//  OnboardingGreetingView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/15/24.
//

import SwiftUI

struct OnboardingGreetingView: View {
    @EnvironmentObject private var notificationManager: NotificationManager
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    
    @State var isHidden = false
    @State var textIndex = 0
    
    private let doneButtonLabel = "좋아요"
    
    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                Image(.onboardingFrezia)
                    .resizable()
                    .scaledToFit()
                
                OnboardingTextBox(texts: onboardingViewModel.onboardingGreetingTexts[textIndex])
                    .font(.titleL)
                    .foregroundColor(.brownPrimary)
            }
            
            VStack {
                Spacer()
                
                OnboardingDoneButton(action: onboardingViewModel.moveToOnboardingIntroductionView, label: doneButtonLabel)
                    .foregroundColor(.yellowTertiary)
                    .background {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(.brownPrimary)
                    }
                    .hidden(isHidden)
            }
        }
        .padding(20)
        .toolbar {
            OnboardingSkipButton(action: onboardingViewModel.moveToOnboardingNamingView)
                .hidden(isHidden)
        }
        .onChange(of: notificationManager.isNotificationSet) { newValue in
            if newValue {
                increaseTextIndex()
            }
        }
    }
}

// MARK: - functions

extension OnboardingGreetingView {
    private func increaseTextIndex() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            withAnimation(.easeInOut(duration: 1)) {
                isHidden = true
                textIndex += 1
            }
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(NotificationManager.instance)
        .environmentObject(ServiceStateViewModel())
        .environmentObject(OnboardingViewModel())
}
