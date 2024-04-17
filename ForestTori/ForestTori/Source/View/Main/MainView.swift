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
    
    @State private var selectedTab = 0
    @State private var isShowSelectPlantView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(gameManager.chapter.chatperBackgroundImage)
                    .resizable()
                    .scaledToFit()
                
                VStack {
                    mainHeader
                    
                    Spacer()
                    
                    PlantView(isShowSelectPlantView: $isShowSelectPlantView)
                        .environmentObject(gameManager)
                        .environmentObject(viewModel)
                    
                    customTabBar
                }
                
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
                
                if viewModel.isCompleteMission {
                    Color.black.opacity(0.4)
                    
                    CompleteMissionView()
                        .environmentObject(gameManager)
                        .onAppear {
                            gameManager.completeMission()
                        }
                }
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
}

// MARK: MainView Elements

extension MainView {
    private var mainHeader: some View {
        HStack {
            NavigationLink(destination: GardenView()
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

#Preview {
    MainView()
}
