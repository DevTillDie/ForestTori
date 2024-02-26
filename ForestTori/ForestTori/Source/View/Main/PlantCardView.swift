//
//  PlantCardView.swift
//  ForestTori
//
//  Created by hyebin on 2/26/24.
//

import SwiftUI

// MARK: Carousel에 보여질 CardView

struct PlantCardView: View {
    @EnvironmentObject var gameManager: GameManager
    @Binding var isShowSelectPlantView: Bool
    
    var plant: Plant
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
            
            VStack(spacing: 0) {
                Text(plant.mainQuest)
                    .foregroundStyle(.greenSecondary)
                    .font(.titleL)
                    .padding(.bottom, 6)
                
                Text(plant.characterName)
                    .font(.subtitleM)
                    .padding(.bottom, 16)
                
                Image(plant.characterImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8)
                    .padding(.bottom, 16)
                
                Text(plant.characterDescription)
                    .font(.bodyS)
                    .foregroundStyle(.gray50)
                    .lineSpacing(1)
                    .padding(.bottom, 16)
                
                Spacer()
                
                Button {
                    gameManager.selectPlant(plant: plant)
                    isShowSelectPlantView = false
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.brownPrimary)
                            .frame(height: 41)
                        
                        Text("선택하기")
                            .font(.titleS)
                            .foregroundColor(.white)
                    }
                    
                }
                
            }
            .padding(20)
        }
    }
}
