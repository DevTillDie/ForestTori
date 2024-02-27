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
    
    var body: some View {
        VStack(spacing: 0) {
            dialogueBox
                .hidden(viewModel.isShowDialogueBox)
            
            Spacer()
            
            addNewPlantButton
                .hidden(viewModel.isShowAddButton)
            
            PlantPotView(sceneViewName: viewModel.plantName)
                .scaledToFit()
                .frame(width: viewModel.plantWidth)
                .padding(.bottom, 16)
            
            missionBox
                .hidden(viewModel.isShowMissionBox)
        }
        .padding(.top, 24)
        .padding(.bottom, 20)
        .onChange(of: gameManager.isSelectPlant) {
            if  gameManager.isSelectPlant {
                viewModel.setNewPlant(plant: gameManager.user.selectedPlant)
            } else {
                viewModel.setEmptyPot()
            }
        }
    }
}

// MARK: PlantView Elements

extension PlantView {
    private var dialogueBox: some View {
        ZStack {
            Image("DialogFrame")
                .resizable()
                .scaledToFit()
                .overlay(alignment: .top) {
                    VStack(alignment: .trailing, spacing: 0) {
                        Text(viewModel.dialogueText)
                        
                        Button {
                            viewModel.showNextDialogue()
                        } label: {
                            Image("DialogButton")
                                .resizable()
                                .frame(width: 16, height: 10)
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 14)
                }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 26)
    }
    
    private var addNewPlantButton: some View {
        Button {
            isShowSelectPlantView = true
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
                    Text("창문 30분 열어 환기하기")
                        .font(.titleL)
                        .foregroundColor(.brownPrimary)
                    
                    Spacer()
                    
                    Button {
                        viewModel.isTapDoneButton = true
                        viewModel.completMission()
                        // TODO: Show Write Diary View
                    } label: {
                        Image(systemName: viewModel.isTapDoneButton ? "checkmark.circle.fill" : "circle")
                            .resizable()
                            .frame(width: 38, height: 38)
                            .foregroundColor(viewModel.isTapDoneButton ? .greenPrimary : .brownSecondary)
                    }
                    .disabled(viewModel.isDisableDoneButton)
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, 20)
    }
}

#Preview {
    MainView()
}
