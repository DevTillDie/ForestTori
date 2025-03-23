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
    @EnvironmentObject var mainViewModel: MainViewModel
    
    @Binding var isShowSelectPlantView: Bool
    
    private var isCompleted: Bool {
        if gameManager.user.completedPlants.contains(where: {$0.value.contains(where: {$0.id == plant.id})}) {
            return true
        } else {
            return false
        }
    }
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
                
                Text(plant.name)
                    .font(.subtitleM)
                    .padding(.bottom, 16)
                
                Image(plant.image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8)
                    .padding(.bottom, 16)
                
                Text(plant.description.splitCharacter())
                    .font(.bodyS)
                    .foregroundStyle(.gray50)
                    .lineSpacing(1)
                    .padding(.bottom, 16)
                
                Spacer()
                
                Button {
                    gameManager.selectPlant(plant: plant)
                    
                    withAnimation(.easeInOut(duration: 0.5)) {
                        mainViewModel.setNewPlant(plant: plant)
                    }
                    
                    withAnimation(.easeInOut(duration: 0.6)) {
                        isShowSelectPlantView = false
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.brownPrimary, lineWidth: 2)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(isCompleted ? .white : .brownPrimary)
                            )
                            .frame(height: 41)
                        
                        Text("선택하기")
                            .font(.titleS)
                            .foregroundColor(isCompleted ? .brownPrimary : .white)
                    }
                }
                .disabled(isCompleted)
            }
            .padding(20)
        }
    }
}
