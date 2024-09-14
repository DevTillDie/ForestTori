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
    @StateObject private var keyboardHandler = KeyboardHandler()
    
    @State private var selectedTab = 0
    @State private var plantPlayStatus: [Bool] = UserDefaults.standard.array(forKey: "plantPlayStatus") as? [Bool] ?? [false, false, false]
    @State private var plantLevels: [Int] = UserDefaults.standard.array(forKey: "plantLevels") as? [Int] ?? [0, 0, 0]
    @State private var isShowSelectPlantView = false
    
    private let notAvailableLine = "현재 식물의 성장 완료 후 잠금 해제됩니다."
    
    var body: some View {
        NavigationView {
            ZStack {
                ZStack {
                    Image(gameManager.chapter.chatperBackgroundImage)
                        .resizable()
                        .ignoresSafeArea()
                    VStack(spacing: 0) {
                        mainHeader
                        
                        if !gameManager.isPlantSelected[selectedTab] {
                            EmptyPlantPotView(isShowSelectPlantView: $isShowSelectPlantView)
                                .transition(.opacity)
                        } else {
                            PlantView(isShowSelectPlantView: $isShowSelectPlantView)
                                .environmentObject(gameManager)
                                .environmentObject(viewModel)
                        }
                        
                        notAvailableAlert
                        
                        customTabBar
                    }
                    
                    SelectPlantView( isShowSelectPlantView: $isShowSelectPlantView, tabIndex: selectedTab)
                        .environmentObject(gameManager)
                }
                .ignoresSafeArea()
            }

            showCompleteMission
        }
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $viewModel.isShowHistoryView) {
            WriteHistoryView(
                isComplete: $viewModel.isCompleteTodayMission,
                isShowHistoryView: $viewModel.isShowHistoryView,
                currentStatus: $viewModel.missionStatus,
                plantName: viewModel.plantName
            )
            .environmentObject(keyboardHandler)
        }
        .onAppear {
            if gameManager.isSelectPlant {
                viewModel.setNewPlant(plant: gameManager.user.selectedPlant)
            } else {
                viewModel.setEmptyPot()
            }
        }
        .onChange(of: gameManager.isSelectPlant) { _ in
            if gameManager.isSelectPlant {
                viewModel.setNewPlant(plant: gameManager.user.selectedPlant)
            } else {
                viewModel.setEmptyPot()
            }
        }
        .onChange(of: viewModel.showEnding) { _ in
            gameManager.completeMission()
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
                Image("MainButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
            }
            
            Spacer()
            
            ProgressView(value: viewModel.progressValue, total: 100)
                .frame(width: 119, height: 50)
                .progressViewStyle(
                    ProgressStyle(
                        width: 119,
                        color: .brown.opacity(0.8),
                        text: viewModel.plantName
                    )
                )
                .hidden(gameManager.isSelectPlant)
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
                selectedTab = 0
            } label: {
                tabIcon(0)
            }
            
            Button {
                selectedTab = 1
            } label: {
                tabIcon(1)
            }
            .disabled(!gameManager.plantPlayStatus[1])
            .onTapGesture {
                if !gameManager.plantPlayStatus[1] {
                    viewModel.showNotAvailableAlert()
                }
            }
            
            Button {
                selectedTab = 2
            } label: {
                tabIcon(2)
            }
            .disabled(!gameManager.plantPlayStatus[2])
            .onTapGesture {
                if !gameManager.plantPlayStatus[2] {
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
        if index == selectedTab {
            Image(.potSelectedButton)
        } else if gameManager.plantPlayStatus[index] {
            Image(.potButton)
        } else {
            Image(.potLockedButton)
        }
    }
}

// MARK: elements shown based on conditions

extension MainView {
//    private var showSelectPlantView: some View {
//        ZStack {
//            if isShowSelectPlantView {
//                Color.black.opacity(0.4)
//                    .ignoresSafeArea()
//                    .onTapGesture {
//                        withAnimation {
//                            isShowSelectPlantView = false
//                        }
//                    }
//                    .transition(.opacity)
//                
//                Text("식물 친구를 선택해주세요")
//                    .font(.titleM)
//                    .foregroundColor(.white)
//                    .padding(.top, 160)
//                    .frame(maxHeight: .infinity, alignment: .top)
//                    .transition(.move(edge: .bottom))
//                
//                SelectPlantView(isShowSelectPlantView: $isShowSelectPlantView)
//                    .environmentObject(gameManager)
//                    .transition(.move(edge: .bottom))
//            }
//        }
//    }
    
    private var showCompleteMission: some View {
        ZStack {
            if viewModel.isCompleteMission {
                Color.black.opacity(0.4)
                
                CompleteMissionView()
                    .environmentObject(gameManager)
                    .environmentObject(viewModel)
                    .onAppear {
                        if gameManager.user.selectedPlant != nil {
                            viewModel.isShowCompleteMissionView = true
                            gameManager.completeMission()
                        }
                    }
            }
        }
        .hidden(viewModel.isShowCompleteMissionView)
    }
}

#Preview {
    MainView()
        .environmentObject(GameManager())
        .environmentObject(ServiceStateViewModel())
}
