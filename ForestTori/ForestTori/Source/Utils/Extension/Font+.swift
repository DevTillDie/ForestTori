//
//  Font+.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/14/24.
//

import SwiftUI

// MARK: - Font

extension Font {
    // Title
    static let titleXL = pretendard(size: 20, .bold)
    static let titleL = pretendard(size: 18, .bold)
    static let titleM = pretendard(size: 16, .bold)
    static let titleS = pretendard(size: 14, .bold)
    static let titleXS = pretendard(size: 12, .bold)
    static let titleXXS = pretendard(size: 10, .bold)
    
    // Subtitle
    static let subtitleXL = pretendard(size: 20, .semiBold)
    static let subtitleL = pretendard(size: 18, .semiBold)
    static let subtitleM = pretendard(size: 16, .semiBold)
    static let subtitleS = pretendard(size: 14, .semiBold)
    static let subtitleXS = pretendard(size: 12, .semiBold)
    static let subtitleXXS = pretendard(size: 10, .semiBold)
    
    // Body
    static let bodyXL = pretendard(size: 20, .regular)
    static let bodyL = pretendard(size: 18, .regular)
    static let bodyM = pretendard(size: 16, .regular)
    static let bodyS = pretendard(size: 14, .regular)
    static let bodyXS = pretendard(size: 12, .regular)
    static let bodyXXS = pretendard(size: 10, .regular)
    
    // Caption
    static let captionXL = pretendard(size: 20, .light)
    static let captionL = pretendard(size: 18, .light)
    static let captionM = pretendard(size: 16, .light)
    static let captionS = pretendard(size: 14, .light)
    static let captionXS = pretendard(size: 12, .light)
    static let captionXXS = pretendard(size: 10, .light)
    
    // Font Weight
    enum Pretendard {
        case light
        case regular
        case semiBold
        case bold
        
        var value: String {
            switch self {
            case .light:
                return "Pretendard-Light"
            case .regular:
                return "Pretendard-Regular"
            case .semiBold:
                return "Pretendard-SemiBold"
            case .bold:
                return "Pretendard-Bold"
            }
        }
    }
    
    /// 커스텀 폰트를 반환합니다.
    ///
    /// - Parameters:
    ///     - size: 폰트 사이즈
    ///     - type: 폰트 굵기
    static func pretendard(size: CGFloat, _ type: Pretendard) -> Font {
        return .custom(type.value, size: size)
    }
}
