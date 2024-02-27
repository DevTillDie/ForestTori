//
//  ContentView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/20/24.
//

import SwiftUI

struct ServiceStateView: View {
    @StateObject var onboardingViewModel = OnboardingViewModel()
    
    var body: some View {
//        stateBasedView
        MainView()
    }
}

// MARK: - stateBasedView

extension ServiceStateView {
    @ViewBuilder private var stateBasedView: some View {
        // TODO: enum으로 관리
        if onboardingViewModel.isFirstLaunching {
            OnboardingView(onboardingViewModel: onboardingViewModel)
        } else {
            MainView()
        }
    }
}

#Preview {
    ServiceStateView()
}
