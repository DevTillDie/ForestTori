//
//  CompleteMissionView.swift
//  ForestTori
//
//  Created by hyebin on 2/27/24.
//

import SwiftUI

struct CompleteMissionView: View {
    @EnvironmentObject var gameManager: GameManager
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
            
            VStack {
                Text("챕터 완료")
                    .foregroundStyle(.greenSecondary)
                    .font(.titleL)
                    .padding(.bottom, 6)
                
                Text("민들레씨들이 용기를 얻었어요")
                    .font(.subtitleM)
                
                Image("ChapterThumbnail1")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 186)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .cornerRadius(8)
                
                VStack(spacing: 0) {
                    Text("여름, 안녕? 토리야")
                        .font(.titleS)
                        .foregroundStyle(.brownPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 4)
                    
                    Text("여름이 찾아오고 장마가 시작되었어요. 오두막에서 홀로 반짝이는 빗방울을 구경하던 토리에게 “나는 누구일까?”하는 궁금증이 생겼어요.")
                        .font(.bodyS)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 23)
              
                HStack(spacing: 16) {
                    Button {
                        
                    } label: {
                        Text("정원으로")
                            .font(.titleS)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 38)
                            .padding(.vertical, 10)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.brownPrimary)
                            }
                    }
                    
                    Button {
                        gameManager.completeMission()
                    } label: {
                        Text("메인으로")
                            .font(.titleS)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 38)
                            .padding(.vertical, 10)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.brownPrimary)
                            }
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            }
            .padding(.top, 22)
        }
        .scaledToFit()
        .padding(.horizontal, 43)
    }
}

#Preview {
    CompleteMissionView()
}
