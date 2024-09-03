//
//  ChapterButtonStyle.swift
//  ForestTori
//
//  Created by hyebin on 9/3/24.
//

import SwiftUI

struct ChapterButtonStyle: ButtonStyle {
    var isDisabled: Bool
    var isSelected: Bool
  
    func makeBody(configuration: Configuration) -> some View {
        if isDisabled {
            configuration.label
                .font(.titleS)
                .foregroundColor(.ivoryTransparency50)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.ivoryTransparency50, lineWidth: 2)
                        .frame(width: 50, height: 37)
                }
        } else {
            configuration.label
                .font(.titleS)
                .foregroundColor(isSelected ? .gray10 : .brownPrimary)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? .greenPrimary : .ivoryTransparency50)
                        .frame(width: 50, height: 37)
                }
        }
    }
}
