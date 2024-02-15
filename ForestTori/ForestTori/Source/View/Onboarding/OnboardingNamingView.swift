//
//  OnboardingNamingView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/18/24.
//

import SwiftUI

struct OnboardingNamingView: View {
    @ObservedObject var onboardingViewModel: OnboardingViewModel
    
    @State var isNamingCompleted = false
    @State var isSettingViewPresented = false
    @State var textIndex = 0
    @State var timer: Timer?
    
    let doneButtonLabel = "시작하기"
    let imageName = "OnboardingFrezia"
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            onboardingTextBox(texts: onboardingViewModel.onboardingNamingTexts[textIndex])
                .font(.titleL)
                .foregroundColor(.brownPrimary)
            
            Spacer()
            
            OnboardingDoneButton(action: completeOnboardingProcess, label: doneButtonLabel)
                .font(.titleL)
                .foregroundColor(.yellowTertiary)
                .background {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.brownPrimary)
                }
                .opacity(0)
        }
        .padding(20)
        .toolbar {
            OnboardingSkipButton(action: moveToOnboardingCompletionView)
                .opacity(setHidden(!isNamingCompleted))
        }
        .overlay {
            overlayView
        }
        .onAppear {
            showNameSettingView()
        }
        .onChange(of: isNamingCompleted) {
            increaseTextIndex()
        }
    }
}

extension OnboardingNamingView {
    @ViewBuilder private var overlayView: some View {
        if isSettingViewPresented {
            NameSettingView(onboardingViewModel: onboardingViewModel, isCompleted: $isNamingCompleted, isPresented: $isSettingViewPresented, textIndex: $textIndex)
        } else {
            EmptyView()
        }
    }
}

// MARK: - functions

extension OnboardingNamingView {
    private func completeOnboardingProcess() {
        onboardingViewModel.isFirstLaunching = false
    }
    
    private func moveToOnboardingCompletionView() {
        stopTimer()
        withAnimation(.easeInOut(duration: 1)) {
            onboardingViewModel.type = .completion
        }
    }
    
    private func showNameSettingView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 1)) {
                isSettingViewPresented = true
            }
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
            
            if textIndex > 2 {
                stopTimer()
                Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { _ in
                        onboardingViewModel.type = .completion
                }
            }
        }
    }
}

// MARK: - UI
extension OnboardingNamingView {
    private func setHidden(_ isHidden: Bool) -> CGFloat {
            return isHidden ? 0 : 1
    }
}

#Preview {
    OnboardingNamingView(onboardingViewModel: OnboardingViewModel())
}
