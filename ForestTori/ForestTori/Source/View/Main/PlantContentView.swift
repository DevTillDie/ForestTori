//
//  PlantContentView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 9/14/24.
//

import SwiftUI

struct PlantContentView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var viewModel: MainViewModel
    @StateObject private var keyboardHandler = KeyboardHandler()
    
    @Binding var isShowSelectPlantView: Bool
    
    private let emptyPotFileName = "Emptypot.scn"
    private let potWidth: CGFloat = 300
    private let url = "https://www.1365.go.kr/vols/1472176623798/wpge/volsguide1365.do"
    let index: Int
    
    var body: some View {
        ZStack {
            if let plant = viewModel.plantStatuses[index]?.plant {
                PlantPotView(sceneViewName: plant.character3DFiles[viewModel.plantStatuses[index]!.missionDay])
                    .scaledToFit()
            } else {
                VStack {
                    addNewPlantButton
                    
                    PlantPotView(sceneViewName: emptyPotFileName)
                        .scaledToFit()
                        .frame(width: potWidth)
                }
                .padding(.top, 100)
            }
            
            VStack(spacing: 0) {
                ZStack {
                    dialogueBox
                        .hidden(viewModel.plantStatuses[index]!.missionStatus == .receivingMission || viewModel.plantStatuses[index]!.missionStatus == .completed)
                    
                    infoButton
                        .hidden(viewModel.plantStatuses[index]!.missionStatus == .inProgress && viewModel.plantStatuses[index]!.plant!.characterName == "목화나무")
                }
                
                Spacer()
                
                missionBox
                    .hidden(viewModel.plantStatuses[index]!.missionStatus == .inProgress || viewModel.plantStatuses[index]!.missionStatus == .completed)
            }
        }
        .padding(.top, 24)
        .padding(.bottom, 10)
        .fullScreenCover(isPresented: $viewModel.isShowHistoryView) {
            WriteHistoryView(
                isComplete: $viewModel.isCompleteTodayMission,
                isShowHistoryView: $viewModel.isShowHistoryView,
                currentStatus: Binding(
                    get: { viewModel.plantStatuses[index]!.missionStatus },
                    set: { _ in
                        if viewModel.isCompleteTodayMission {
                            viewModel.plantStatuses[index]!.missionStatus = .completed } else {
                                viewModel.plantStatuses[index]!.missionStatus = .inProgress
                            }
                    }
                        ),
                plantName: viewModel.plantStatuses[index]!.plant!.characterName
            )
            .environmentObject(keyboardHandler)
        }
    }
}

extension PlantContentView {
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
    
    private var dialogueBox: some View {
        let fontSize: CGFloat = 17.5
        
        return Image(.dialogFrame)
            .resizable()
            .scaledToFit()
            .overlay(alignment: .top) {
                ZStack(alignment: .topLeading) {
                    Text(viewModel.dialogueText)
                        .font(.pretendard(size: fontSize, .regular))
                        .tracking(-0.015 * fontSize)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 16)
                    
                    Image(.dialogButton)
                        .resizable()
                        .frame(width: 16, height: 10)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .padding(.bottom, 18)
                        .padding(.trailing, 18)
                }
                .padding(.vertical, 8)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 26)
            .onTapGesture {
                viewModel.showNextDialogue(index: index)
            }
            .hidden(!(viewModel.plantStatuses[index]!.isStoryCompleted))
    }
    
    private var infoButton: some View {
        Button {
            viewModel.openWebsite(urlString: url)
        } label: {
            Image(.infoButton)
                .resizable()
                .frame(width: 40, height: 34)
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
                        viewModel.plantStatuses[index]!.missionStatus = .done
                        viewModel.isShowHistoryView = true
                    } label: {
                        Image(systemName: viewModel.plantStatuses[index]!.missionStatus == .done || viewModel.plantStatuses[index]!.missionStatus == .completed ? "checkmark.circle.fill" : "circle")
                            .resizable()
                            .frame(width: 38, height: 38)
                            .foregroundColor(viewModel.plantStatuses[index]!.missionStatus == .done || viewModel.plantStatuses[index]!.missionStatus == .completed ? .greenPrimary : .brownSecondary)
                    }
                    .disabled(viewModel.plantStatuses[index]!.missionStatus != .inProgress)
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, 20)
    }
}

#Preview {
    PlantContentView(isShowSelectPlantView: .constant(false), index: 0)
        .environmentObject(GameManager())
        .environmentObject(MainViewModel())
}
