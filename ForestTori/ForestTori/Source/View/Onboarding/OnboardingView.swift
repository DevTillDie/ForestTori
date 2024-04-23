//
//  OnboardingView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/15/24.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var serviceStateViewModel: ServiceStateViewModel
    @StateObject var onboardingViewModel = OnboardingViewModel()
    
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
            OnboardingGreetingView()
                .environmentObject(onboardingViewModel)
        case .introduction:
            OnboardingIntroductionView()
                .environmentObject(onboardingViewModel)
        case .naming:
            OnboardingNamingView()
                .environmentObject(onboardingViewModel)
        case .completion:
            OnboardingCompletionView()
                .environmentObject(serviceStateViewModel)
                .environmentObject(onboardingViewModel)
        }
    }
}

#Preview {
    OnboardingView(onboardingViewModel: OnboardingViewModel())
}
