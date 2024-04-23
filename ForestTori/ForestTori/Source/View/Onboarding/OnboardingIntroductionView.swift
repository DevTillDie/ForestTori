//
//  OnboardingIntroductionView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/15/24.
//

import SwiftUI

struct OnboardingIntroductionView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    
    @State var isHidden = false
    
    private let doneButtonLabel = "준비됐어요!"
    private let firstPageDescription = "firstPage"
    private let lastPageDescription = "sixthPage"
    private let leftCompactChevron = "chevron.compact.left"
    private let rightCompactChevron = "chevron.compact.right"
    
    var body: some View {
        VStack {
            TabView {
                ForEach(onboardingViewModel.onboardingIntroductionData) { introduction in
                    introductionContent(data: introduction)
                }
            }
            Button {
                onboardingViewModel.type = .naming
            } label: {
                Text(doneButtonLabel)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.yellowTertiary)
                    .background(.brownPrimary)
                    .cornerRadius(50)
            }
            .hidden(isHidden)
            .padding(20)
        }
        .toolbar {
            OnboardingSkipButton(action: onboardingViewModel.moveToOnboardingNamingView)
        }
        .tabViewStyle(.page)
        .onAppear {
            setPageIndicatorColor()
        }
    }
}

// MARK: - introductionContent

extension OnboardingIntroductionView {
    @ViewBuilder private func introductionContent(data: OnboardingIntroductionData) -> some View {
        VStack(spacing: 30) {
            HStack {
                Image(systemName: leftCompactChevron)
                    .foregroundColor(.brownSecondary)
                    .hidden(data.description != firstPageDescription)
                
                Image(data.imageName)
                    .resizable()
                    .scaledToFit()
                
                Image(systemName: rightCompactChevron)
                    .foregroundColor(.brownSecondary)
                    .hidden(data.description != lastPageDescription)
            }
            OnboardingTextBox(texts: data.introductionTexts)
                .font(.titleM)
                .foregroundColor(.gray50)
        }
        .padding(20)
        .onAppear {
            showDoneButton(description: data.description)
        }
    }
}

// MARK: - UI

extension OnboardingIntroductionView {
    private func setPageIndicatorColor() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .greenPrimary
        UIPageControl.appearance().pageIndicatorTintColor = .beigeTertiary
    }
    
    private func showDoneButton(description: String) {
        if description == lastPageDescription {
            withAnimation(.easeInOut(duration: 1)) {
                isHidden = true
            }
        } else {
            withAnimation(.easeInOut(duration: 1)) {
                isHidden = false
            }
        }
    }
}

#Preview {
    OnboardingView()
}
