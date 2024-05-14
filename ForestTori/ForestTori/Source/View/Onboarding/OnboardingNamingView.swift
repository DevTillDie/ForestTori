//
//  OnboardingNamingView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/18/24.
//

import SwiftUI

struct OnboardingNamingView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    
    @State var isNamingCompleted = false
    @State var isSettingViewPresented = false
    @State var textIndex = 0
    @State var timer: Timer?
    
    private let doneButtonLabel = "시작하기"
    private let lastIndex = 3
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(.onboardingFrezia)
                .resizable()
                .scaledToFit()
            
            OnboardingTextBox(texts: onboardingViewModel.onboardingNamingTexts[textIndex])
                .font(.titleL)
                .foregroundColor(.brownPrimary)
            
            Spacer()
        }
        .padding(20)
        .toolbar {
            OnboardingSkipButton(action: skipToOnboardingCompletionView)
                .hidden(isNamingCompleted)
        }
        .overlay {
            overlayView
        }
        .onAppear {
            showNameSettingView()
        }
        .onChange(of: isNamingCompleted) { _ in
            increaseTextIndex()
        }
    }
}

extension OnboardingNamingView {
    @ViewBuilder private var overlayView: some View {
        if isSettingViewPresented {
            NameSettingView(isCompleted: $isNamingCompleted, isPresented: $isSettingViewPresented, textIndex: $textIndex)
        } else {
            EmptyView()
        }
    }
}

// MARK: - functions

extension OnboardingNamingView {
    private func skipToOnboardingCompletionView() {
        stopTimer()
        withAnimation(.easeInOut(duration: 1)) {
            onboardingViewModel.moveToOnboardingCompletionView()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
    }
    
    private func increaseTextIndex() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 1)) {
                textIndex += 1
            }
            
            if textIndex == lastIndex {
                stopTimer()
                Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { _ in
                        onboardingViewModel.moveToOnboardingCompletionView()
                }
            }
        }
    }
}

// MARK: - UI

extension OnboardingNamingView {
    private func showNameSettingView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 1)) {
                isSettingViewPresented = true
            }
        }
    }
}

#Preview {
    OnboardingView()
}
