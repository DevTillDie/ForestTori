//
//  HistoryView.swift
//  ForestTori
//
//  Created by hyebin on 4/27/24.
//

import SwiftUI

struct HistoryView: View {
    
    var body: some View {
        VStack {
            Text("매일 창문 30분 열어 환기하기")
                .foregroundStyle(.brownPrimary)
                .font(.titleL)
            
            Text("민들레씨")
                .foregroundStyle(.greenSecondary)
                .font(.titleM)
            
            Image("")
            
            Text("겁 많은 민들레씨들이 하늘로 날아기지 못하고 있었어요. 용기를 낼 수 있게 창문을 열러 민들레씨들을 도와줬어요.")
                .font(.bodyS)
            
            LazyVStack {
                HStack {
                    Spacer()
                    Image(systemName: "house")
                        .aspectRatio(1, contentMode: .fit)
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("민들레꽃 모양 구름을 본 날이었다.")
                            .font(.titleM)
                        
                        Text("2024.00.00")
                            .font(.caption)
                    }
                    Spacer()
                }
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.beigeSecondary)
                        .fill(.gray10)
                }
               
            }
        }
    }
}

#Preview {
    HistoryView()
}
