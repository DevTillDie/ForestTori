//
//  MainViewModel.swift
//  ForestTori
//
//  Created by hyebin on 2/17/24.
//

import SwiftUI

//  - dialogueText: View에서 보여지는 대사
//  - dialogues: 파일에서 읽어온 데이터를 저장하는 배열
//  - currentDialogueIndex: dialogues 배열에 접근하기 위한 index
//  - currentLineIndex: dialogues배열 중 currentDialogueIndex에 해당하는 lines 배열에 접근하기 위한 index

class MainViewModel: ObservableObject {
    @Published var plant3DFileName = "Emptypot.scn"
    @Published var plantWidth: CGFloat = 200
    
    @Published var dialogueText = ""
    
    @Published var isShowDialogueBox = false
    @Published var isShowAddButton = true
    @Published var isShowMissionBox = false
    @Published var isTapDoneButton = false
    @Published var isDisableDoneButton = false
    @Published var isCompleteMission = false
    
    private var plant: Plant?
    private var missionDay = 0
    private var dialogues = [Dialogue]()
    private var currentDialogueIndex = 0
    private var currentLineIndex = 0
    
    func setNewPlant(plant: Plant?) {
        self.plant = plant
        
        if let plant = plant {
            getDialogue(plant.characterFileName)
            isShowAddButton = false
            isShowDialogueBox = true
            plant3DFileName = plant.character3DFiles[missionDay]
            plantWidth = 350
            
            dialogueText = dialogues[currentDialogueIndex].lines[currentLineIndex]
            currentLineIndex += 1
        }
    }
    
    func setEmptyPot() {
        plant3DFileName = "Emptypot.scn"
        missionDay = 0
        plantWidth = 200
        
        dialogueText = ""
        
        isShowDialogueBox = false
        isShowAddButton = true
        isShowMissionBox = false
        isTapDoneButton = false
        isDisableDoneButton = false
        isCompleteMission = false
        
        currentDialogueIndex = 0
        currentLineIndex = 0
    }
    
    func showNextDialogue() {
        if currentLineIndex == dialogues[currentDialogueIndex].lines.count {
            isShowDialogueBox = false
            isShowMissionBox = true
            isTapDoneButton = false
            isDisableDoneButton = false
            
            if dialogues[currentDialogueIndex].type == "Ending" {
                nextDay()
            }
        } else {
            dialogueText = dialogues[currentDialogueIndex].lines[currentLineIndex]
            currentLineIndex += 1
        }
    }
    
    func completMission() {
        currentDialogueIndex += 1
        currentLineIndex = 0
        
        isShowDialogueBox = true
        isDisableDoneButton = true
        showNextDialogue()
    }
    
    // csv 파일에 저장된 식물의 대사를 반환
    private func getDialogue(_ fileName: String) {
        dialogues = []
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: "tsv") else {
            return
        }
        
        do {
            let url = URL(filePath: path)
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            
            if let dataArr = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: "\t")}) {
                for row in dataArr[1..<dataArr.count] {
                    // TODO: "닉네임"을 db에 저장된 사용자 닉네임으로 변경
                    let lines = Array(row[3...])
                        .map {$0.replacingOccurrences(of: "(userName)", with: "닉네임")}
                        .map {$0.replacingOccurrences(of: "\\n", with: "\n")}
                        .map {$0.replacingOccurrences(of: "\r", with: "")}
                        .filter {!$0.isEmpty}
                    
                    dialogues.append(Dialogue(
                        id: Int(row[0]) ?? 0,
                        day: Int(row[1]) ?? 0,
                        type: row[2],
                        lines: lines
                    ))
                }
            }
        } catch {
            print("Error reading CSV file")
        }
        print(dialogues)
    }
    
    private func nextDay() {
        missionDay += 1

        if let plant = plant {
            if missionDay == plant.totalDay {
                isCompleteMission = true
            } else {
                plant3DFileName = plant.character3DFiles[missionDay]
            }
        }
    }
}
