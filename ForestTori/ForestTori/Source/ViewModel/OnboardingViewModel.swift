//
//  OnboardingViewModel.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/15/24.
//

import Foundation
import SwiftUI

/// OnboardingView에서 사용되는 데이터를 관리하는 클래스
///
/// - type: 온보딩 프로세스 유형
/// - onbaordingIntroductionData: 서비스 소개에 필요한 데이터
class OnboardingViewModel: ObservableObject {
    @AppStorage("_isFirstLaunching") var isFirstLaunching = true
    @AppStorage("userName") var userName = ""
    
    @Published var type: OnboardingType = .greeting
    @Published var onboardingGreetingTexts: [[OnboardingText]] = []
    @Published var onboardingIntroductionData: [OnboardingIntroductionData] = []
    @Published var onboardingNamingTexts: [[OnboardingText]] = []
    @Published var onboardingCompletionText: [OnboardingText] = []
    
    // 데이터 초기화
    init() {
        setOnboardingGreetingTexts()
        setOnboardingIntroductionData()
        setOnboardingNamingTexts()
//        setOnboardingCompletionText()
    }
    
    /// 온보딩 프로세스 유형
    ///
    /// - greeting: 사용자 환영 단계
    /// - introduction: 서비스 설명 단계
    /// - naming: 사용자 이름 설정 단계
    /// - completion: 온보딩 완료 단계
    enum OnboardingType {
        case greeting, introduction, naming, completion
    }
}

// MARK: - Data Initialization

extension OnboardingViewModel {
    private func setOnboardingGreetingTexts() {
        let firstText = [
            OnboardingText(text: "반가워요,"),
            OnboardingText(text: "\(Text("토리의 숲").foregroundColor(.greenPrimary))에 오신 걸 환영해요!"),
        ]
        
        let secondText = [
            OnboardingText(text: "저는 문지기 요정, 프리지아예요."),
            OnboardingText(text: "\(Text("토리의 숲").foregroundColor(.greenPrimary))을 안내해 드릴게요."),
        ]
        
        onboardingGreetingTexts = [firstText, secondText]
    }
    
    private func setOnboardingIntroductionData() {
        let firstPage = OnboardingIntroductionData(description: "firstPage",
                                               imageName: "OnboardingTab1",
                                               introductionTexts: [
                                                OnboardingText(text: "나만의 화분에서 \(Text("특별한 식물 친구").foregroundColor(.brownPrimary))를 키워봐요!"),
                                                OnboardingText(text: "\(Text("빈 화분").foregroundColor(.brownPrimary))을 누르면 \(Text("원하는 퀘스트").foregroundColor(.brownPrimary))를 선택해"),
                                                OnboardingText(text: "식물을 심을 수 있어요."),
                                               ])
        
        let secondPage = OnboardingIntroductionData(description: "secondPage",
                                                imageName: "OnboardingTab2",
                                                introductionTexts: [
                                                    OnboardingText(text: "나의 \(Text("뿌듯한 마음").foregroundColor(.brownPrimary))을 기록하는 \(Text("성장일지").foregroundColor(.brownPrimary))를 작성해"),
                                                    OnboardingText(text: "퀘스트를 완료해 보세요."),
                                                    OnboardingText(text: " "),
                                                ])
        
        let thirdPage = OnboardingIntroductionData(description: "thridPage",
                                               imageName: "OnboardingTab3",
                                               introductionTexts: [
                                                OnboardingText(text: "퀘스트를 완료하면,"),
                                                OnboardingText(text: "\(Text("식물들도 함께 성장").foregroundColor(.brownPrimary))하는 걸 볼 수 있어요."),
                                                OnboardingText(text: " "),
                                               ])
        
        let fourthPage = OnboardingIntroductionData(description: "fourthPage",
                                               imageName: "OnboardingTab4",
                                                introductionTexts: [
                                                OnboardingText(text: "토리의 숲은 \(Text("계젤에 따라 네 챕터").foregroundColor(.brownPrimary))가 진행돼요."),
                                                OnboardingText(text: "한 \(Text("챕터당 최대 3개의 화분").foregroundColor(.brownPrimary))까지 키울 수 있답니다."),
                                                OnboardingText(text: " "),
                                               ])
        
        let fifthPage = OnboardingIntroductionData(description: "fifthPage",
                                                imageName: "OnboardingTab5",
                                               introductionTexts: [
                                                    OnboardingText(text: "한 챕터에서 선택한 모든 \(Text("미션을 다 끝내면").foregroundColor(.brownPrimary)),"),
                                                    OnboardingText(text: "\(Text("정원").foregroundColor(.brownPrimary))에서 내가 키워낸 식물들을 만날 수 있어요."),
                                                    OnboardingText(text: " "),
                                                ])
        
        let sixthPage = OnboardingIntroductionData(description: "sixthPage",
                                               imageName: "OnboardingTab6",
                                               introductionTexts: [
                                                OnboardingText(text: "열심히 가꾼 정원은 \(Text("AR").foregroundColor(.brownPrimary))을 띄울 수 있어요."),
                                                OnboardingText(text: "나만의 공간에서 식물들과 함께 해요!"),
                                                OnboardingText(text: " "),
                                               ])
    
        onboardingIntroductionData = [firstPage, secondPage, thirdPage, fourthPage, fifthPage, sixthPage]
    }
    
    func setOnboardingNamingTexts() {
        let firstText = [
            OnboardingText(text: "식물을 키울 준비가 되었나요?"),
            OnboardingText(text: "그럼, \(Text("토리의 이름을 알려주세요").foregroundColor(.greenPrimary))."),
        ]
        
        let secondText = [
            OnboardingText(text: "멋진 이름이네요."),
            OnboardingText(text: "\(Text(userName).foregroundColor(.greenPrimary))\(Text(":)").foregroundColor(.greenPrimary))"),
        ]
        
        let thirdText = [
            OnboardingText(text: "여기 \(Text(userName).foregroundStyle(.greenPrimary))를 위해"),
            OnboardingText(text: "신비한 화분을 줄게요."),
        ]
        
        let fourthText = [
            OnboardingText(text: "이제부터 \(Text(userName).foregroundStyle(.greenPrimary))의"),
            OnboardingText(text: "마법 능력으로 식물을 잘 키워주세요."),
        ]
        
        onboardingNamingTexts = [firstText, secondText, thirdText, fourthText]
    }
    
    func setOnboardingCompletionText() {
        let text = [
            OnboardingText(text: "첫 챕터는 새로운 시작을 의미하는"),
            OnboardingText(text: "새싹이 반짝이는 계절, 봄이에요."),
            OnboardingText(text: "\(Text(userName).foregroundColor(.greenPrimary))의 시작을 응원할게요!"),
        ]
        
        onboardingCompletionText = text
    }
}
