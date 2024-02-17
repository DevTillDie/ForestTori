//
//  PlantView.swift
//  ForestTori
//
//  Created by hyebin on 2/15/24.
//

import SwiftUI

struct PlantView: View {
    @State private var isTapDoneButton = false
    @State private var isShowDialogueBox = false
    @State private var isShowAddButton = true
    @State private var isShowMissionBox = false
    
    private let plantName = "Emptypot.scn"
//    private let plantName = "Dandelion1.scn"
    private var plantWidth: CGFloat {
        plantName == "Emptypot.scn" ? 200 : 350
    }
    
    var body: some View {
        VStack(spacing: 0) {
            dialogueBox
                .hidden(isShowDialogueBox)
            
            Spacer()
            addNewPlantButton
                .hidden(isShowAddButton)
            
            PlantPotView(sceneViewName: plantName)
                .scaledToFit()
                .frame(width: plantWidth)
                .padding(.bottom, 16)
            
            missionBox
                .hidden(isShowMissionBox)
        }
        .padding(.top, 24)
        .padding(.bottom, 20)
    }
}

extension PlantView {
    private var dialogueBox: some View {
        ZStack {
            Image("DialogFrame")
                .resizable()
                .scaledToFit()
                .overlay(alignment: .top) {
                    VStack(alignment: .trailing, spacing: 0) {
                        Text("하루에 30분씩 창문을 열어 두고 날아갈 연습을 하면 나아질 수 있을 것 같아.")
                        
                        Image("DialogButton")
                            .resizable()
                            .frame(width: 16, height: 10)
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
            //TODO: show select plant Carousel
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
                        isTapDoneButton.toggle()
                        //TODO: Show Write Diary View
                    } label: {
                        Image(systemName: isTapDoneButton ? "checkmark.circle.fill" : "circle")
                            .resizable()
                            .frame(width: 38, height: 38)
                            .foregroundColor(isTapDoneButton ? .greenPrimary : .brownSecondary)
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, 20)
    }
}

#Preview {
    MainView()
}
