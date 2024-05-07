//
//  EndingViewModel.swift
//  ForestTori
//
//  Created by Nayeon Kim on 3/1/24.
//

import Foundation
import SwiftUI

///  EndingView에서 사용하는 데이터를 관리하는 클래스
///
///  - endingTexts: 엔딩에서 사용하는 텍스트 데이터 집합
class EpilogueViewModel: ObservableObject {
    @Published var endingTexts: [[OnboardingText]] = []
    
    private let userName = UserDefaults.standard.value(forKey: "userName") as? String ?? "토리"
}

extension EpilogueViewModel {
    func completeEndingProcess() {
        // TODO: 엔딩 완료 함수 수정
        print("complete ending process")
    }
}

// MARK: Data Initialization

extension EpilogueViewModel {
    private func setEndingTexts() {
        let firstText = [
            OnboardingText(text: "\(Text(userName).foregroundColor(.greenPrimary))"),
            OnboardingText(text: "정말 열심히 식물을 키워주었군요!"),
            OnboardingText(text: "정원이 예쁜 식물들로 가득해졌네요."),
        ]
        
        let secondText = [
            OnboardingText(text: "그런데, 여길 봐요!"),
            OnboardingText(text: "방금 새 싹을 틔운 화분 하나가 남아있어요."),
            OnboardingText(text: " ")
        ]
        
        let thirdText = [
            OnboardingText(text: "사실, 이 새싹은 바로"),
            OnboardingText(text: "\(Text(userName).foregroundColor(.greenPrimary)) 당신이에요."),
            OnboardingText(text: " "),
        ]
        
        let fourthText = [
            OnboardingText(text: "이제는 토리의 숲을 벗어나"),
            OnboardingText(text: "더 넓은 세상에서 자라날 준비가 된 것 같네요."),
            OnboardingText(text: " ")
        ]
        
        let fifthText = [
            OnboardingText(text: "토리의 숲이 그리워질 때면,"),
            OnboardingText(text: "언제든 다시 찾아와요."),
            OnboardingText(text: " ")
        ]
        
        endingTexts = [firstText, secondText, thirdText, fourthText, fifthText]
    }
}
