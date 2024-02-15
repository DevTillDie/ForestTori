//
//  OnboardingView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/15/24.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var onboardingViewModel: OnboardingViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.yellowTertiary
                    .ignoresSafeArea()
                
                onboardingScreen
            }
            
        }
    }
}

// MARK: - onboardingScreen

extension OnboardingView {
    @ViewBuilder private var onboardingScreen: some View {
        switch onboardingViewModel.type {
        case .greeting:
            OnboardingGreetingView(onboardingViewModel: onboardingViewModel)
        case .introduction:
            OnboardingIntroductionView(onboardingViewModel: onboardingViewModel)
        case .naming:
            OnboardingNamingView(onboardingViewModel: onboardingViewModel)
        case .completion:
            OnboardingCompletionView(onboardingViewModel: onboardingViewModel)
        }
    }
}

#Preview {
    OnboardingView(onboardingViewModel: OnboardingViewModel())
}
