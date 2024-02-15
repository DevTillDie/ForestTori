//
//  OnboardingIntroduction.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/16/24.
//

import Foundation
import SwiftUI

/// OnboardingIntroductionView에서 사용하는 데이터 집합
///
/// - id: 기본 식별자
/// - desciption: 소개 데이터가 표시되는 페이지 정보
/// - imageName: 소개 페이지에 업로드될 이미지 파일 이름
/// - introductionTexts: 소개 페이지에 업로드될 텍스트 집합
struct OnboardingIntroductionData: Identifiable {
    let id = UUID()
    let description: String
    let imageName: String
    let introductionTexts: [OnboardingText]
}

/// 온보딩에서 사용하는 텍스트 모델
///
/// - id: 기본 식별자
/// - text: 서비스 소개 텍스트 (띄어쓰기 기준)
struct OnboardingText: Identifiable {
    let id = UUID()
    // 텍스트 일부만 특정 포맷으로 설정하기 위해 String이 아닌 LocalizedStringKey 사용
    let text: LocalizedStringKey
}
