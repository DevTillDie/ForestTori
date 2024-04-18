//
//  MainView.swift
//  ForestTori
//
//  Created by hyebin on 2/15/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var gameManager = GameManager()
    @StateObject var viewModel = MainViewModel()
    @StateObject private var keyboardHandler = KeyboardHandler()
    
    @State private var selectedTab = 0
    @State private var isShowSelectPlantView = false
    
    var body: some View {
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
        .onChange(of: gameManager.isSelectPlant) {
            if  gameManager.isSelectPlant {
                viewModel.setNewPlant(plant: gameManager.user.selectedPlant)
            } else {
                viewModel.setEmptyPot()
            }
        }
    }
}

// MARK: MainView Elements

extension MainView {
    private var mainHeader: some View {
        HStack {
            Button {
                // TODO: Move to Garden
            } label: {
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
                
                Text("식물 친구를 선택해주세요")
                    .font(.titleM)
                    .foregroundColor(.white)
                    .padding(.top, 160)
                    .frame(maxHeight: .infinity, alignment: .top)
                
                SelectPlantView(isShowSelectPlantView: $isShowSelectPlantView)
                    .environmentObject(gameManager)
            }
        }
    }
    
    private var showCompleteMission: some View {
        ZStack {
            if viewModel.isCompleteMission {
                Color.black.opacity(0.4)
                
                CompleteMissionView()
                    .environmentObject(gameManager)
                    .onAppear {
                        gameManager.completeMission()
                    }
            }
        }
    }
    
    private var showHistoryView: some View {
        ZStack {
            if viewModel.isShowHistoryView {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            viewModel.isShowHistoryView = false
                            viewModel.isTapDoneButton = false
                        }
                    }
                    .transition(.opacity)
                
                HistoryView(
                    isComplete: $viewModel.isComplteTodayMission,
                    isShowHistoryView: $viewModel.isShowHistoryView,
                    isTapDoneButton: $viewModel.isTapDoneButton
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
}
