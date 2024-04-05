//
//  GardenView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/24/24.
//

import SwiftUI

struct GardenView: View {
    @StateObject var gameManager: GameManager
    private let noPlantCaption = "아직 다 키운 식물이 없어요."
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(.springBackground)
                    .resizable()
                    .scaledToFit()
                
                VStack(spacing: 40) {
                    Spacer()
                    Spacer()
                    
                    GardenScene()
                        .scaledToFit()
                    
                    noPlantCaptionBox
                        .hidden(gameManager.user.completedPlants.isEmpty)
                    
                    Spacer()
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    toMainButton
                }
                ToolbarItem(placement: .topBarTrailing) {
                    totalProgressBar
                }
                ToolbarItem(placement: .bottomBar) {
                    ARButton
                }
            }
            .ignoresSafeArea()
        }
    }
}

// MARK: - toMainButton

extension GardenView {
    @ViewBuilder private var toMainButton: some View {
        Button {
            // action
        } label: {
            Image(.gardenButton)
        }
        .padding(.top)
    }
}

// MARK: - totalProgressBar

extension GardenView {
    @ViewBuilder private var totalProgressBar: some View {
        ZStack {
            Image(.gardenProgressSpring3)
            VStack {
                Text("봄, 숲을 만나다")
                    .font(.titleS)
                Text("21%")
                    .font(.titleL)
            }
            .foregroundColor(.white)
            .shadow(color: .gray30, radius: 4.0)
        }
        .padding(.top)
    }
}

// MARK: - noPlantCaptionBox

extension GardenView {
    @ViewBuilder private var noPlantCaptionBox: some View {
        Text(noPlantCaption)
            .font(.bodyM)
            .foregroundColor(.white)
            .padding(.horizontal, 25)
            .padding(.vertical, 6)
            .background {
                Capsule()
                    .foregroundColor(.black)
                    .opacity(0.4)
            }
    }
}

// MARK: - ARButton

extension GardenView {
    @ViewBuilder private var ARButton: some View {
        Button {
            // action
        } label: {
            Image(.arButton)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 50.0, minHeight: 50.0)
        }
    }
}

#Preview {
    GardenView(gameManager: GameManager())
}
