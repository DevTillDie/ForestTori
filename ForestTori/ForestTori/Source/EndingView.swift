//
//  EndingView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/29/24.
//

import SwiftUI

struct EndingView: View {
    @ObservedObject var endingViewModel: EndingViewModel
    
    @State var isHidden = false
    @State var textIndex = 0
    @State var timer: Timer?
    
    private let doneButtonLabel = "메인으로"
    private let lastIndex = 4
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.yellowTertiary
                    .ignoresSafeArea()
                
                ZStack {
                    VStack(spacing: 30) {
                        Image(.onboardingFrezia)
                            .resizable()
                            .scaledToFit()
                        
                        OnboardingTextBox(texts: endingViewModel.endingTexts[textIndex])
                            .font(.titleL)
                            .foregroundColor(.brownPrimary)
                    }
                    
                    VStack {
                        Spacer()
                        
                        OnboardingDoneButton(action: endingViewModel.completeEndingProcess, label: doneButtonLabel)
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
                    OnboardingSkipButton(action: skipToLastText)
                }
            }
            .onAppear {
                increaseTextIndex()
            }
        }
    }
}

// MARK: - functions

extension EndingView {
    private func skipToLastText() {
        stopTimer()
        withAnimation(.easeInOut(duration: 1)) {
            textIndex = lastIndex
            isHidden = true
        }
    }

    private func stopTimer() {
        timer?.invalidate()
    }
    
    private func increaseTextIndex() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            if textIndex < lastIndex {
                withAnimation(.easeInOut(duration: 1.5)) {
                    textIndex += 1
                }
            } else {
                stopTimer()
                isHidden = true
            }
        }
    }
}

#Preview {
    EndingView(endingViewModel: EndingViewModel())
}
