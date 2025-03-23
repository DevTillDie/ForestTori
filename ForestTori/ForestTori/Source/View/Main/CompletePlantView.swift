//
//  CompletePlantView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 12/21/24.
//

import SwiftUI

struct CompletePlantView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var mainViewModel: MainViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
            
            VStack {
                Text("성장 완료!")
                    .foregroundStyle(.greenSecondary)
                    .font(.titleL)
                    .padding(.bottom, 6)
                
                Text(gameManager.user.selectedPlant?.completeTitle ?? "")
                    .font(.subtitleM)
                
                Image(gameManager.user.selectedPlant?.completeImage ?? "")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 186)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .cornerRadius(8)
                
                Text(gameManager.user.selectedPlant?.completeDescription ?? "")
                    .font(.bodyS)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 23)
                
                HStack(spacing: 16) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            mainViewModel.isCompletePlant = false
                        }
                    } label: {
                        Text("닫기")
                            .font(.titleS)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.brownPrimary)
                            }
                    }
                    
                    Button {
                        if mainViewModel.currentTab < 2 {
                            mainViewModel.currentTab += 1
                        }
                        
                        withAnimation(.easeInOut(duration: 0.5)) {
                            mainViewModel.isCompletePlant = false
                        }
                    } label: {
                        Text("새 식물 만나기")
                            .font(.titleS)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.brownPrimary)
                            }
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
            }
            .padding(.top, 22)
        }
        .scaledToFit()
        .padding(.horizontal, 43)
    }
}

#Preview {
    CompletePlantView()
        .environmentObject(GameManager())
        .environmentObject(MainViewModel())
}
