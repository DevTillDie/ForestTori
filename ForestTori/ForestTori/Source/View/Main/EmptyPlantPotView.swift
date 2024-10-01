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
    private let potWidth: CGFloat = 320
    
    var body: some View {
        ZStack {
            PlantPotView(sceneViewName: emptyPotFileName)
                .scaledToFit()
                .frame(width: potWidth)
            
            VStack(spacing: 0) {
                addNewPlantButton
                Spacer()
            }
            .padding(.top, 24)
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
