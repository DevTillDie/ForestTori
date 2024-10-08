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
    
    @StateObject private var viewModel = GardenViewModel()
    
    @State private var selectedHistoryIndex: Int?
    @State private var isShowDialogueBox = false
    @State private var isShowHistoryView = false
    @State private var showHistoryDetail = false
    @State private var selectedPlant: GardenPlant?
    @State private var selectedHistory: (image: UIImage, date: String, record: String)?
    
    @State private var currentChapter = 1
    
    private let noPlantCaption = "아직 다 키운 식물이 없어요."
    private let notOpenChapterCaption = "아직 열리지 않은 계절이에요."
    private let summerMessage = "여름 하늘은 봄보다 더 높아져서 더 멀리까지 바라볼 수 있는 거 알아?"
    var totalProgressValue: Double?
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(viewModel.backgroundImages[currentChapter])
                    .resizable()
                    .scaledToFit()
                
                VStack {
                    gardenHeader
                        .hidden(gameManager.user.chapterProgress < 5)
                    
                    Spacer()
                    
                    VStack(spacing: 0) {
                        dialogueBox
                            .hidden(isShowDialogueBox)
                        
                        TabView(selection: $currentChapter) {
                            ForEach(1..<5) { index in
                                GardenScene(
                                    selectedPlant: $selectedPlant,
                                    showHistoryView: $isShowHistoryView,
                                    dialogueMessage: $viewModel.dialogueMessage,
                                    showDialogueBox: $isShowDialogueBox,
                                    chapterPlants: loadChapterPlants(),
                                    currentChapter: index)
                                .scaledToFit()
                                .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        
                        ZStack {
                            noPlantCaptionBox
                                .hidden(viewModel.isShowNoPlantBox && !viewModel.isShowNotChapterBox)
                            
                            notOpenChapterBox
                                .hidden(viewModel.isShowNotChapterBox)
                        }
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 60)
                    
                    Spacer()
                    
                    chapterButton
                    
                    Spacer()
                    
                    ARButton
                }
                
                showHistoryView
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .onChange(of: currentChapter) { _ in
                if gameManager.user.completedPlants[currentChapter] == nil {
                    viewModel.isShowNoPlantBox = true
                }
            }
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
                        text: viewModel.chapterTitle[currentChapter]
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
                    Text(viewModel.dialogueMessage)
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
                isShowDialogueBox = false
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
    
    private var notOpenChapterBox: some View {
        Text(notOpenChapterCaption)
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
                        selectedHistory: $selectedHistory,
                        backgroundImage: viewModel.backgroundImages[currentChapter]
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea([.bottom, .horizontal])
                }
            }
        }
        .ignoresSafeArea()
        .animation(.interactiveSpring(), value: isShowHistoryView)
    }
}

// MARK: - chapterButton

extension GardenView {
    private var chapterButton: some View {
        return HStack {
            ForEach(1...4, id: \.self) {idx in
                Button {
                    if gameManager.user.chapterProgress >= idx {
                        withAnimation {
                            currentChapter = idx
                        }
                    } else {
                        viewModel.isShowNotChapterBox = true
                    }
                    
                } label: {
                    Text(viewModel.chapter[idx])
                }
                .buttonStyle(
                    ChapterButtonStyle(
                        isDisabled: gameManager.user.chapterProgress < idx,
                        isSelected: currentChapter == idx)
                )
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal, 80)
        .padding(.bottom, 40)
    }
}

// MARK: - ARButton

extension GardenView {
    @ViewBuilder private var ARButton: some View {
        NavigationLink(
            destination: GardenARView(
                chapterPlants: loadChapterPlants(),
                currentChapter: currentChapter
            )
        ) {
            Text("AR로 보기")
                .foregroundColor(.greenPrimary)
                .font(.titleS)
                .padding()
                .padding(.horizontal)
                .background {
                    RoundedRectangle(cornerRadius: 100)
                        .fill(.gray10)
                }
        }
        .padding(.bottom, 42)
    }
}

extension GardenView {
    func loadChapterPlants() -> [GardenPlant]? {
        if let plants = gameManager.user.completedPlants.filter({$0.key == currentChapter}).first {
            return plants.value
        }
        
        return nil
    }
}

#Preview {
    GardenView(totalProgressValue: MainViewModel().totalProgressValue)
        .environmentObject(GameManager())
}
