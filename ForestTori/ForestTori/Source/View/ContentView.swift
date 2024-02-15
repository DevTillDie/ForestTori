//
//  ContentView.swift
//  ForestTori
//
//  Created by hyebin on 1/11/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var onboardingViewModel = OnboardingViewModel()
    
    var body: some View {
        contentView
    }
}

extension ContentView {
    @ViewBuilder private var contentView: some View {
        if onboardingViewModel.isFirstLaunching {
            OnboardingView(onboardingViewModel: onboardingViewModel)
        } else {
            Text("Main")
        }
    }
}

#Preview {
    ContentView()
}
