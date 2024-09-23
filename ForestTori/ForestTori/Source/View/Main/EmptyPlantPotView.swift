//
//  EmptyPlantPotView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 9/14/24.
//

import SwiftUI

struct EmptyPlantPotView: View {
    @Binding var isShowSelectPlantView: Bool
    
    private let emptyPotFileName = "Emptypot.scn"
    private let potWidth: CGFloat = 250
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            addNewPlantButton
            
            PlantPotView(sceneViewName: emptyPotFileName)
                .scaledToFit()
                .frame(width: potWidth)
        }
        .padding(.top, 24)
        .padding(.bottom, 20)
    }
}

extension EmptyPlantPotView {
    private var addNewPlantButton: some View {
        Button {
            withAnimation {
                isShowSelectPlantView = true
            }
        } label: {
            Image(systemName: "plus.square.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.greenSecondary)
                .padding(.bottom, 4)
        }
    }
}

#Preview {
    EmptyPlantPotView(isShowSelectPlantView: .constant(false))
}
