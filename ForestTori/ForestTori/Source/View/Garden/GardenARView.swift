//
//  ARView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 4/14/24.
//

import SwiftUI

struct GardenARView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var gardenARViewModel = GardenARViewModel()
    
    private let backButtonLabel = "돌아가기"
    private let backButtonImage = "chevron.backward"
    private let cameraButtomImage = "button.programmable"
    var chapterPlants: [GardenPlant]?
    var currentChapter: Int
    
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
                
                GardenScene(
                    selectedPlant: .constant(nil),
                    showHistoryView: .constant(false),
                    dialogueMessage: .constant(""),
                    showDialogueBox: .constant(false),
                    chapterPlants: chapterPlants,
                    currentChapter: currentChapter
                )
                .scaledToFit()
                .padding(40)
                
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
