//
//  MainView.swift
//  ForestTori
//
//  Created by hyebin on 2/15/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var gameManger = GameManager()
    
    @State private var selectedTab = 0
    @State private var isShowSelectPlantView = true
    
    var body: some View {
        ZStack {
            Image("SpringBackground")
                .resizable()
                .scaledToFit()
            
            VStack {
                mainHeader
                
                Spacer()
                
                PlantView(isShowSelectPlantView: $isShowSelectPlantView)
                
                customTabBar
            }
            
            if isShowSelectPlantView {
                Color.black.opacity(0.4)

                Text("식물 친구를 선택해주세요")
                    .font(.titleM)
                    .foregroundColor(.white)
                    .padding(.top, 160)
                    .frame(maxHeight: .infinity, alignment: .top)
                
                VStack {
                    SelectPlantView(isShowSelectPlantView: $isShowSelectPlantView)
                        .environmentObject(gameManger)
                }
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: MainView Elements

extension MainView {
    private var mainHeader: some View {
        HStack {
            Button {
                //TODO: Move to Garden
            } label: {
                Image("MainButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
            }
            
            Spacer()
            
            Image("PotProgress1")
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
