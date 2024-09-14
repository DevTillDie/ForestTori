//
//  PlantView.swift
//  ForestTori
//
//  Created by hyebin on 2/15/24.
//

import SwiftUI

struct PlantView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var viewModel: MainViewModel
    
    @Binding var isShowSelectPlantView: Bool
    
    private let url = "https://www.1365.go.kr/vols/1472176623798/wpge/volsguide1365.do"
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                dialogueBox
                    .hidden(viewModel.missionStatus == .receivingMission || viewModel.missionStatus == .completed)
                
                Button {
                    viewModel.openWebsite(urlString: url)
                } label: {
                    Image(.infoButton)
                        .resizable()
                        .frame(width: 40, height: 34)
                }
                .hidden(viewModel.missionStatus == .inProgress && viewModel.plantName == "목화나무")
            }
            
            Spacer()
            
            addNewPlantButton
                .hidden(viewModel.missionStatus == .none)
            
            PlantPotView(sceneViewName: viewModel.plant3DFileName)
                .scaledToFit()
                .frame(width: viewModel.plantWidth)
            
            missionBox
                .hidden(viewModel.missionStatus == .inProgress || viewModel.missionStatus == .completed)
        }
        .padding(.top, 24)
        .padding(.bottom, 10)
    }
}

// MARK: PlantView Elements

extension PlantView {
    private var dialogueBox: some View {
        let fontSize: CGFloat = 17.5
        
        return Image("DialogFrame")
            .resizable()
            .scaledToFit()
            .overlay(alignment: .top) {
                ZStack(alignment: .topLeading) {
                    Text(viewModel.dialogueText.splitCharacter())
                        .font(.pretendard(size: fontSize, .regular))
                        .tracking(-0.015 * fontSize)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 16)
                    
                    Image("DialogButton")
                        .resizable()
                        .frame(width: 16, height: 10)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .padding(.bottom, 18)
                        .padding(.trailing, 18)
                }
                .padding(.vertical, 10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 26)
            .onTapGesture {
                viewModel.showNextDialogue()
            }
            .hidden(gameManager.isSelectPlant)
    }
    
    private var addNewPlantButton: some View {
        Button {
            withAnimation {
                isShowSelectPlantView = true
            }
        } label: {
            Image(systemName: "plus.square.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.greenSecondary)
                .padding(.bottom, 4)
        }
    }
    
    private var missionBox: some View {
        Capsule()
            .fill(.white)
            .frame(height: 68)
            .overlay {
                HStack {
                    Text(viewModel.missionText)
                        .font(.titleL)
                        .foregroundColor(.brownPrimary)
                    
                    Spacer()
                    
                    Button {
                        viewModel.missionStatus = .done
                        viewModel.isShowHistoryView = true
                    } label: {
                        Image(systemName: viewModel.missionStatus == .done || viewModel.missionStatus == .completed ? "checkmark.circle.fill" : "circle")
                            .resizable()
                            .frame(width: 38, height: 38)
                            .foregroundColor(viewModel.missionStatus == .done || viewModel.missionStatus == .completed ? .greenPrimary : .brownSecondary)
                    }
                    .disabled(viewModel.missionStatus != .inProgress)
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, 20)
    }
}

#Preview {
    MainView()
        .environmentObject(GameManager())
        .environmentObject(ServiceStateViewModel())
}
