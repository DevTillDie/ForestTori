//
//  GardenView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/24/24.
//

import SwiftUI

struct GardenView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gameManager: GameManager
    
    @State var showSummerMessage = true
    
    private let noPlantCaption = "아직 다 키운 식물이 없어요."
    private let summerMessage = "여름 하늘은 봄보다 더 높아져서 더 멀리까지 바라볼 수 있는 거 알아?"
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(gameManager.chapter.chatperBackgroundImage)
                    .resizable()
                    .scaledToFit()
                
                VStack {
                    gardenHeader
                        .hidden(gameManager.user.chapterProgress <= 4)
                    
                    Spacer()
                    
                    VStack(spacing: 0) {
                        dialogueBox
                            .hidden(gameManager.chapter.chapterId == 2 && showSummerMessage)
                        
                        GardenScene()
                            .environmentObject(gameManager)
                            .scaledToFit()
                        
                        noPlantCaptionBox
                            .hidden(gameManager.user.completedPlants.isEmpty)
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 60)
                    
                    Spacer()
                    
                    ARButton
                }
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
        }
    }
}

// MARK: - toMainButton

extension GardenView {
    @ViewBuilder private var gardenHeader: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(.gardenButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
            }
            
            Spacer()
            
            // TODO: TotalProgressBar 수정
            ZStack {
                Image(.gardenProgressSpring3)
                VStack {
                    Text(gameManager.chapter.chapterTitle)
                        .font(.titleS)
                    Text("21%")
                        .font(.titleL)
                }
                .foregroundColor(.white)
                .shadow(color: .gray30, radius: 4.0)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 69)
        .padding(.bottom, 8)
    }
}

// MARK: - dialogueBox

extension GardenView {
    // TODO: 컴포넌트화
    private var dialogueBox: some View {
        Image("DialogFrame")
            .resizable()
            .scaledToFit()
            .overlay(alignment: .top) {
                ZStack(alignment: .topLeading) {
                    Text(summerMessage)
                        .font(.pretendard(size: 17.5, .regular))
                        .foregroundStyle(Color.black)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(1)
                        .padding(.horizontal, 16)
                    
                    Image("DialogButton")
                        .resizable()
                        .frame(width: 16, height: 10)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .padding(.bottom, 18)
                        .padding(.trailing, 18)
                }
                .padding(.vertical, 12)
                
            }
            .padding(.horizontal, 20)
            .onTapGesture {
                showSummerMessage = false
            }
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
        NavigationLink(destination: GardenARView()) {
            Image(.arButton)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 50.0, minHeight: 50.0)
        }
        .padding(.bottom, 42)
    }
}

#Preview {
    GardenView()
}
