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
    
    private let notAvailableLine = "현재 식물의 성장 완료 후 잠금 해제됩니다."
    
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
                    
                    notAvailableAlert
                    
                    customTabBar
                }
                
                SelectPlantView(isShowSelectPlantView: $isShowSelectPlantView)
                    .environmentObject(gameManager)
                    .environmentObject(viewModel)
                
                showCompleteChapter
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
        .onChange(of: viewModel.isShowEnding) { _ in
            gameManager.completePlant()
            withAnimation {
                serviceStateViewModel.state = .ending
            }
        }
        .onChange(of: gameManager.user.selectedPlant?.characterName) { newPlantName in
            if let newPlantName {
                notificationManager.scheduleNotification(for: newPlantName)
            }
        }
    }
}

// MARK: MainView Elements

extension MainView {
    private var mainHeader: some View {
        HStack {
            NavigationLink(destination: GardenView(totalProgressValue: viewModel.totalProgressValue)
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
            
            if let plantName = viewModel.plantStatuses[viewModel.currentTab]?.plant?.characterName {
                ProgressView(value: viewModel.plantStatuses[viewModel.currentTab]!.progressValue, total: 100)
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
    
    private var notAvailableAlert: some View {
        Text(notAvailableLine)
            .font(.bodyM)
            .foregroundStyle(.white)
            .padding(.horizontal, 25)
            .padding(.vertical, 6)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.black.opacity(0.4))
            }
            .padding(.bottom, 10)
            .hidden(viewModel.isShowNotAvailable)
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
            .disabled(!viewModel.plantStatuses[0]!.isStoryCompleted)
            .onTapGesture {
                if !viewModel.plantStatuses[0]!.isStoryCompleted {
                    viewModel.showNotAvailableAlert()
                }
            }
            
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    viewModel.currentTab = 2
                }
            } label: {
                tabIcon(2)
            }
            .disabled(!viewModel.plantStatuses[1]!.isStoryCompleted)
            .onTapGesture {
                if !viewModel.plantStatuses[1]!.isStoryCompleted {
                    viewModel.showNotAvailableAlert()
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
        } else if (index == 0) || (viewModel.plantStatuses[index - 1]!.isStoryCompleted)  {
            Image(.potButton)
        } else {
            Image(.potLockedButton)
        }
    }
}

// MARK: elements shown based on conditions

extension MainView {
    private var showCompleteChapter: some View {
        ZStack {
            if viewModel.isCompleteChapter {
                Color.black.opacity(0.4)
                
                CompleteChapterView()
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
}

#Preview {
    MainView()
        .environmentObject(GameManager())
        .environmentObject(ServiceStateViewModel())
}
