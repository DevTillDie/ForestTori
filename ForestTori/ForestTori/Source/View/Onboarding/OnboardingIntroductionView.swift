//
//  OnboardingIntroductionView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/15/24.
//

import SwiftUI

struct OnboardingIntroductionView: View {
    @ObservedObject var onboardingViewModel: OnboardingViewModel
    
    @State var isHidden = true
    
    let doneButtonLabel = "준비됐어요!"
    let firstPageDescription = "firstPage"
    let lastPageDescription = "sixthPage"
    let leftCompactChevron = "chevron.compact.left"
    let rightCompactChevron = "chevron.compact.right"
    
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
            .opacity(setHidden(isHidden))
            .padding(20)
        }
        .toolbar {
            OnboardingSkipButton(action: moveToOnboardingNamingView)
        }
        .tabViewStyle(.page)
        .onAppear {
            setPageIndicatorColor()
        }
    }
}

// MARK: functions

extension OnboardingIntroductionView {
    private func moveToOnboardingNamingView() {
        onboardingViewModel.type = .naming
    }
    
    private func showDoneButton(description: String) {
        if description == lastPageDescription {
            withAnimation(.easeInOut(duration: 1)) {
                isHidden = false
            }
        } else {
            withAnimation(.easeInOut(duration: 1)) {
                isHidden = true
            }
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
                    .opacity(setHidden(data.description == firstPageDescription))
                
                Image(data.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Image(systemName: rightCompactChevron)
                    .foregroundColor(.brownSecondary)
                    .opacity(setHidden(data.description == lastPageDescription))
            }
            onboardingTextBox(texts: data.introductionTexts)
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
    private func setHidden(_ isHidden: Bool) -> CGFloat {
        return isHidden ? 0 : 1
    }
    
    private func setPageIndicatorColor() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .greenPrimary
        UIPageControl.appearance().pageIndicatorTintColor = .beigeTertiary
    }
}

#Preview {
    OnboardingIntroductionView(onboardingViewModel: OnboardingViewModel())
}
