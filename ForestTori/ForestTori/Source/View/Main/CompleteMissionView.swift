//
//  CompleteMissionView.swift
//  ForestTori
//
//  Created by hyebin on 2/27/24.
//

import SwiftUI

struct CompleteMissionView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var mainViewModel: MainViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
            
            VStack {
                Text("챕터 완료")
                    .foregroundStyle(.greenSecondary)
                    .font(.titleL)
                    .padding(.bottom, 6)
                
                Text(gameManager.chapter.lastChapterEnding)
                    .font(.subtitleM)
                
                Image("ChapterThumbnail\( gameManager.user.chapterProgress)")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 186)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .cornerRadius(8)
                
                VStack(spacing: 0) {
                    Text(gameManager.chapter.chapterTitle)
                        .font(.titleS)
                        .foregroundStyle(.brownPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 4)
                    
                    Text(gameManager.chapter.chapterDescription)
                        .font(.bodyS)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 23)
                
                HStack(spacing: 16) {
                    NavigationLink(destination: GardenView()
                        .environmentObject(gameManager)
                        .navigationBarBackButtonHidden(true)
                        .onAppear {
                            mainViewModel.isShowCompleteMissionView = false
                        }
                        .onDisappear {
                            gameManager.startNewGame()
                        }
                    ) {
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
                        gameManager.startNewGame()
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
        .environmentObject(GameManager())
        .environmentObject(ServiceStateViewModel())
}
