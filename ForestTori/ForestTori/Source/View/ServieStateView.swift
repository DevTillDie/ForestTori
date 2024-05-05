//
//  ContentView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/20/24.
//

import SwiftUI

struct ServiceStateView: View {
    @StateObject var gameManager = GameManager()
    @StateObject var serviceStateViewModel = ServiceStateViewModel()
    
    var body: some View {
        stateBasedView
    }
}

// MARK: - stateBasedView

extension ServiceStateView {
    @ViewBuilder private var stateBasedView: some View {
        switch serviceStateViewModel.state {
        case .onboarding:
            OnboardingView()
                .environmentObject(serviceStateViewModel)
        case .main:
            MainView()
                .transition(.move(edge: .trailing))
                .environmentObject(gameManager)
                .environmentObject(serviceStateViewModel)
        case .ending:
            EndingView()
                .transition(.move(edge: .trailing))
                .environmentObject(gameManager)
        }
    }
}

#Preview {
    ServiceStateView()
}
