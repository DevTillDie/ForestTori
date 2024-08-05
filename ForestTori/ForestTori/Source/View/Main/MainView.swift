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
    @State private var isShowSelectPlantView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(gameManager.chapter.chatperBackgroundImage)
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    mainHeader
                    
                    Spacer()
                    
                    PlantView(isShowSelectPlantView: $isShowSelectPlantView)
                        .environmentObject(gameManager)
                        .environmentObject(viewModel)
                    
                    customTabBar
                }
                
                showSelectPlantView
                
                showCompleteMission
                
                showHistoryView
            }
            .ignoresSafeArea()
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
    
    private var customTabBar: some View {
        HStack(spacing: 20) {
            Button {
                selectedTab = 0
            } label: {
                Image(selectedTab == 0 ? "PotSelectedButton" : "PotLockedButton")
            }
            
            Button {
                selectedTab = 1
            } label: {
                Image(selectedTab == 1 ? "PotSelectedButton" : "PotLockedButton")
            }
            .disabled(true)
            
            Button {
                selectedTab = 2
            } label: {
                Image(selectedTab == 2 ? "PotSelectedButton" : "PotLockedButton")
            }
            .disabled(true)
        }
        .padding(.bottom, 42)
    }
}

// MARK: elements shown based on conditions

extension MainView {
    private var showSelectPlantView: some View {
        ZStack {
            if isShowSelectPlantView {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isShowSelectPlantView = false
                        }
                    }
                    .transition(.opacity)
                
                Text("식물 친구를 선택해주세요")
                    .font(.titleM)
                    .foregroundColor(.white)
                    .padding(.top, 160)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .transition(.move(edge: .bottom))
                
                SelectPlantView(isShowSelectPlantView: $isShowSelectPlantView)
                    .environmentObject(gameManager)
                    .transition(.move(edge: .bottom))
            }
        }
    }
    
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
    
    private var showHistoryView: some View {
        ZStack {
            if viewModel.isShowHistoryView {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            viewModel.isShowHistoryView = false
                            viewModel.missionStatus = .inProgress
                        }
                    }
                    .transition(.opacity)
                
                WriteHistoryView(
                    isComplete: $viewModel.isCompleteTodayMission,
                    isShowHistoryView: $viewModel.isShowHistoryView,
                    currentStatus: $viewModel.missionStatus,
                    plantName: viewModel.plantName
                )
                .padding(.vertical)
                .transition(.move(edge: .bottom))
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.6)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                )
                .padding(.bottom, keyboardHandler.keyboardHeight/4)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.isShowHistoryView)
        .animation(.default, value: keyboardHandler.keyboardHeight)
    }
}

#Preview {
    MainView()
        .environmentObject(GameManager())
        .environmentObject(ServiceStateViewModel())
}
