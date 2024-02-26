//
//  PlantCardView.swift
//  ForestTori
//
//  Created by hyebin on 2/26/24.
//

import SwiftUI

struct PlantCardView: View {
    var plant: TestPlantModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
            
            VStack(spacing: 0) {
                Text(plant.plantMission)
                    .foregroundStyle(.greenSecondary)
                    .font(.titleL)
                    .padding(.bottom, 6)
                
                Text(plant.plantName)
                    .font(.subtitleM)
                    .padding(.bottom, 16)
                
                Image(plant.plantImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8)
                    .padding(.bottom, 16)
                
                Text(plant.plantDescription)
                    .font(.bodyS)
                    .foregroundStyle(.gray50)
                    .lineSpacing(1)
                    .padding(.bottom, 16)
                
                Spacer()
                
                Button {
                    
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
