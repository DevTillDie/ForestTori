//
//  EndingView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/29/24.
//

import SwiftUI

struct EpliogueView: View {
    @EnvironmentObject var gameManager: GameManager
    @StateObject var epilgoueViewModel = EpilogueViewModel()
    
    @Binding var isEpilogueShowed: Bool
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
                        
                        OnboardingTextBox(texts: epilgoueViewModel.endingTexts[textIndex])
                            .font(.titleL)
                            .foregroundColor(.brownPrimary)
                    }
                    
                    VStack {
                        Spacer()
                        
                        NavigationLink(destination: GardenView()
                            .environmentObject(gameManager).navigationBarBackButtonHidden(true)) {
                            Text(doneButtonLabel)
                                .font(.titleL)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.yellowTertiary)
                                .background {
                                    RoundedRectangle(cornerRadius: 50)
                                        .fill(.brownPrimary)
                                }
                                .hidden(isHidden)
                        }
                    }
                }
                .padding(20)
                .toolbar {
                    OnboardingSkipButton(action: skipToLastText)
                        .hidden(!isHidden)
                }
            }
            .onAppear {
                increaseTextIndex()
            }
            .onDisappear {
                isEpilogueShowed = true
            }
        }
    }
}

// MARK: - functions

extension EpliogueView {
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
    EpliogueView(isEpilogueShowed: .constant(false))
}
