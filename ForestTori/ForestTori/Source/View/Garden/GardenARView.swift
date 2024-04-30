//
//  ARView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 4/14/24.
//

import SwiftUI

struct GardenARView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gameManager: GameManager
    @StateObject var gardenARViewModel = GardenARViewModel()
    
    private var backButtonLabel = "돌아가기"
    private var backButtonImage = "chevron.backward"
    private var cameraButtomImage = "button.programmable"
    
    var body: some View {
        ZStack {
            ARView
            
            VStack {
                Spacer()
                
                cameraBottomBar
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - ARView

extension GardenARView {
    @ViewBuilder private var ARView: some View {
        ZStack {
            Color.black
            
            CameraPreview()
            
            VStack {
                Spacer()
                
                GardenScene()
                    .scaledToFit()
                    .environmentObject(gameManager)
                
                Spacer()
                Spacer()
            }
        }
    }
}

// MARK: - cameraBottomBar

extension GardenARView {
    @ViewBuilder private var cameraBottomBar: some View {
        ZStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: backButtonImage)
                    Text(backButtonLabel)
                    
                    Spacer()
                }
                .foregroundColor(.white)
                .font(.subtitleM)
                .padding(.horizontal, 30)
            }
            
            Button {
                if let image = gardenARViewModel.captureScreen() {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
            } label: {
                ZStack {
                    Image(systemName: cameraButtomImage)
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 70, height: 70)
                        .padding(.vertical, 36)
                }
            }
        }
        .background(.black)
    }
}

#Preview {
    GardenARView()
        .environmentObject(GameManager())
}
