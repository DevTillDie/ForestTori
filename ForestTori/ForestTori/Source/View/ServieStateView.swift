//
//  ContentView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/20/24.
//

import SwiftUI

struct ServiceStateView: View {
    @StateObject var gameManager = GameManager()
    @StateObject private var notificationManager = NotificationManager.instance
    @StateObject var serviceStateViewModel = ServiceStateViewModel()
    
    var body: some View {
        stateBasedView
            .onAppear {
                notificationManager.requestAuthorization()
            }
    }
}

// MARK: - stateBasedView

extension ServiceStateView {
    @ViewBuilder private var stateBasedView: some View {
        switch serviceStateViewModel.state {
        case .onboarding:
            OnboardingView()
                .environmentObject(notificationManager)
                .environmentObject(serviceStateViewModel)
        case .main:
            MainView()
                .transition(.move(edge: .trailing))
                .environmentObject(gameManager)
                .environmentObject(notificationManager)
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
