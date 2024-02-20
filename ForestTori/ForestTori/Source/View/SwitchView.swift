//
//  ContentView.swift
//  ForestTori
//
//  Created by hyebin on 1/11/24.
//

import SwiftUI

struct SwitchView: View {
    @StateObject var onboardingViewModel = OnboardingViewModel()
    
    var body: some View {
        switchView
    }
}

extension SwitchView {
    @ViewBuilder private var switchView: some View {
        if onboardingViewModel.isFirstLaunching {
            OnboardingView(onboardingViewModel: onboardingViewModel)
        } else {
            Text("Main")
        }
    }
}

#Preview {
    SwitchView()
}
