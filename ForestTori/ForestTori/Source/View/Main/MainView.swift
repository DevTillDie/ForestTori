//
//  MainView.swift
//  ForestTori
//
//  Created by hyebin on 2/15/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var notificationManager: NotificationManager
    @EnvironmentObject var serviceStateViewModel: ServiceStateViewModel
    @StateObject var viewModel = MainViewModel()
    
    @State private var isShowSelectPlantView = false
    
    private let notAvailableToMove = "현재 식물의 성장 완료 후 잠금 해제됩니다."
    private let notAvailableToSelect = "내일부터 새로운 식물을 만날 수 있어요."
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(gameManager.chapter.chatperBackgroundImage)
                    .resizable()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    mainHeader
                    
                    PlantContentView(isShowSelectPlantView: $isShowSelectPlantView, index: viewModel.currentTab)
                        .environmentObject(gameManager)
                        .environmentObject(viewModel)
                    
                    ZStack {
                        notAvailableToMoveAlert
                            .hidden(!viewModel.isShowNotAvailableToSelect)
                        notAvailableToSelectAlert
                            .hidden(!viewModel.isShowNotAvailableToMove)
                    }
                    
                    customTabBar
                }
                
                SelectPlantView(isShowSelectPlantView: $isShowSelectPlantView)
                    .environmentObject(gameManager)
                    .environmentObject(viewModel)
                
                showCompletePlant
                
                showCompleteChapter
            }
            .ignoresSafeArea()
            .background(
                NavigationLink(
                    destination: GardenView()
                        .environmentObject(gameManager)
                        .navigationBarBackButtonHidden(true)
                        .onDisappear {
                            gameManager.startNewGame()
                        },
                    isActive: $viewModel.navigateToGarden
                ) {
                    EmptyView()
                }
                .hidden()
            )
        }
        .ignoresSafeArea()
        .onChange(of: viewModel.isCompletePlant) { _ in
            gameManager.completePlant()
        }
        .onChange(of: viewModel.isShowEnding) { _ in
            gameManager.completePlant()
            gameManager.completeChapter()
            withAnimation {
                serviceStateViewModel.state = .ending
            }
        }
        .onChange(of: gameManager.user.selectedPlant?.name) { newPlantName in
            if let newPlantName {
                notificationManager.scheduleNotification(for: newPlantName)
            }
        }
        .onAppear {
            viewModel.checkMissionAvailability()
            viewModel.startTimerToCheckDate()
        }
        .onDisappear {
            viewModel.stopTimer()
        }
    }
}

// MARK: MainView Elements

extension MainView {
    private var mainHeader: some View {
        HStack {
            NavigationLink(destination: GardenView()
                .environmentObject(gameManager)
                .navigationBarBackButtonHidden(true)
            ) {
                Image(.mainButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
            }
            .padding(.vertical, 2.5)
            
            Spacer()
            
            if let plantName = viewModel.plantStatuses[viewModel.currentTab].plant?.name {
                ProgressView(value: viewModel.plantStatuses[viewModel.currentTab].progressValue, total: 100)
                    .frame(width: 119, height: 50)
                    .progressViewStyle(
                        ProgressStyle(
                            width: 119,
                            color: .brown.opacity(0.8),
                            text: plantName
                        )
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 69)
        .padding(.bottom, 8)
    }
    
    private var notAvailableToMoveAlert: some View {
        Text(notAvailableToMove)
            .font(.bodyM)
            .foregroundStyle(.white)
            .padding(.horizontal, 25)
            .padding(.vertical, 6)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.black.opacity(0.4))
            }
            .padding(.bottom, 10)
            .hidden(viewModel.isShowNotAvailableToMove)
    }
    
    private var notAvailableToSelectAlert: some View {
        Text(notAvailableToSelect)
            .font(.bodyM)
            .foregroundStyle(.white)
            .padding(.horizontal, 25)
            .padding(.vertical, 6)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.black.opacity(0.4))
            }
            .padding(.bottom, 10)
            .hidden(viewModel.isShowNotAvailableToSelect)
    }
    
    private var customTabBar: some View {
        HStack(spacing: 20) {
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    viewModel.currentTab = 0
                }
            } label: {
                tabIcon(0)
            }
            
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    viewModel.currentTab = 1
                }
            } label: {
                tabIcon(1)
            }
            .disabled(!viewModel.plantStatuses[0].isStoryCompleted)
            .onTapGesture {
                if !viewModel.plantStatuses[0].isStoryCompleted {
                    viewModel.showNotAvailableToMoveAlert()
                }
            }
            
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    viewModel.currentTab = 2
                }
            } label: {
                tabIcon(2)
            }
            .disabled(!viewModel.plantStatuses[1].isStoryCompleted)
            .onTapGesture {
                if !viewModel.plantStatuses[1].isStoryCompleted {
                    viewModel.showNotAvailableToMoveAlert()
                }
            }
        }
        .padding(.bottom, 42)
    }
}

extension MainView {
    @ViewBuilder
    func tabIcon(_ index: Int) -> some View {
        if index == viewModel.currentTab {
            Image(.potSelectedButton)
        } else if (index == 0) || (viewModel.plantStatuses[index - 1].isStoryCompleted) {
            Image(.potButton)
        } else {
            Image(.potLockedButton)
        }
    }
}

// MARK: elements shown based on conditions

extension MainView {
    private var showCompletePlant: some View {
        ZStack {
            if viewModel.isCompletePlant {
                Color.black.opacity(0.4)
                
                CompletePlantView()
                    .environmentObject(gameManager)
                    .environmentObject(viewModel)
                    .onAppear {
                        if gameManager.user.selectedPlant != nil {
                            gameManager.completePlant()
                        }
                    }
            }
        }
    }
    
    private var showCompleteChapter: some View {
        ZStack {
            if viewModel.isCompleteChapter {
                Color.black.opacity(0.4)
                
                CompleteChapterView()
                    .environmentObject(gameManager)
                    .environmentObject(viewModel)
                    .onAppear {
                        if (gameManager.user.selectedPlant != nil) && (gameManager.user.chapterProgress < viewModel.currentChapter) {
                            gameManager.completeChapter()
                        }
                    }
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(GameManager())
        .environmentObject(ServiceStateViewModel())
}
