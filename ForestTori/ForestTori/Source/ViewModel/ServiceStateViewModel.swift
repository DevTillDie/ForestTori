//
//  ServiceStateViewModel.swift
//  ForestTori
//
//  Created by Nayeon Kim on 4/23/24.
//

import SwiftUI

class ServiceStateViewModel: ObservableObject {
    @AppStorage("serviceStatebb6") var state: ServiceState = .onboarding
    
    /// 서비스 상태 유형
    ///
    /// @AppStorage에 저장하기 위해 String으로 선언
    /// - onboarding: 온보딩 단계
    /// - main: 메인 스토리 진행 단계
    /// - ending: 메인 스토리 완료 이후 단계
    enum ServiceState: String {
        case onboarding, main, ending
    }
}
