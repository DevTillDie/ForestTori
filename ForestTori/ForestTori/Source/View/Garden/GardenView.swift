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
    
    @State private var selectedHistoryIndex: Int?
    @State private var showSummerMessage = true
    @State private var isShowHistoryView = false
    @State private var showHistoryDetail = false
    @State private var selectedPlant: Plant?
    @State private var selectedHistory: (image: UIImage, record: String)?
    
    private let noPlantCaption = "아직 다 키운 식물이 없어요."
    private let summerMessage = "여름 하늘은 봄보다 더 높아져서 더 멀리까지 바라볼 수 있는 거 알아?"
    var totalProgressValue: Double?
    
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
                        
                        GardenScene(
                            selectedPlant: $selectedPlant,
                            showHistoryView: $isShowHistoryView
                        )
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
                
                showHistoryView
                
                showDetailHistory
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
            
            ProgressView(value: totalProgressValue ?? 100, total: 100)
                .frame(width: 241, height: 50)
                .progressViewStyle(
                    ProgressStyle(
                        width: 241,
                        color: .ivoryTransparency50,
                        text: gameManager.chapter.chapterTitle
                    )
                )
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

// MARK: - history

extension GardenView {
    private var showHistoryView: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.1)
                .opacity(isShowHistoryView ? 1 : 0)
                .onTapGesture {
                    isShowHistoryView = false
                    selectedHistoryIndex = nil
                }
            
            if isShowHistoryView {
                BottomSheet($isShowHistoryView, height: UIScreen.main.bounds.height * 0.8) {
                    HistoryView(
                        selectedHistoryIndex: $selectedHistoryIndex,
                        isShowHistoryDetail: $showHistoryDetail,
                        plant: $selectedPlant,
                        selectedHistory: $selectedHistory
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea([.bottom, .horizontal])
                }
            }
        }
        .ignoresSafeArea()
        .animation(.interactiveSpring(), value: isShowHistoryView)
    }
    
    private var showDetailHistory: some View {
        ZStack {
            if let history = selectedHistory {
                if showHistoryDetail {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showHistoryDetail = false
                                selectedHistoryIndex = nil
                            }
                        }
                        .transition(.opacity)
                    
                    HistoryDetailView(
                        selectedHistoryIndex: $selectedHistoryIndex,
                        isShowHistoryDetailView: $showHistoryDetail,
                        image: history.image,
                        record: history.record
                    )
                    .padding(.vertical)
                    .transition(.move(edge: .bottom))
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.6)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                    )
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showHistoryDetail)
    }
}

// MARK: - ARButton

extension GardenView {
    @ViewBuilder private var ARButton: some View {
        NavigationLink(destination: GardenARView()
            .environmentObject(gameManager)
        ) {
            Image(.arButton)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 50.0, minHeight: 50.0)
        }
        .padding(.bottom, 42)
    }
}

#Preview {
    GardenView(totalProgressValue: MainViewModel().totalProgressValue)
        .environmentObject(GameManager())
}
