//
//  ProgressStyle.swift
//  ForestTori
//
//  Created by hyebin on 4/12/24.
//

import SwiftUI

struct ProgressStyle: ProgressViewStyle {
    let width: Double
    let color: Color
    let text: String
    
    func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0.0
        
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 45)
                .fill(.clear)
                .stroke(.white, lineWidth: 5)
            
            Rectangle()
                .fill(.clear)
            
            Rectangle()
                .fill(color)
                .frame(width: width * progress)
                .animation(.easeInOut(duration: 0.5), value: progress)
        }
        .mask {
            RoundedRectangle(cornerRadius: 45)
        }
        .overlay {
            VStack {
                Text(text)
                    .font(.titleS)
                Text("\(Int(progress * 100))%")
                    .font(.titleL)
            }
            .foregroundStyle(.white)
        }
    }
}
