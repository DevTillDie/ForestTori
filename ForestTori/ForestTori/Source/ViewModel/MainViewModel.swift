//
//  MainViewModel.swift
//  ForestTori
//
//  Created by hyebin on 2/17/24.
//

import SwiftUI

enum Type {
    case opening
    case ending
}

class MainViewModel: ObservableObject {
    @Published var plantName = "Emptypot.scn"
    @Published var missionDay = 0
    @Published var plantWidth: CGFloat = 200
    
    @Published var dialogueText = ""
    
    @Published var isShowDialogueBox = false
    @Published var isShowAddButton = true
    @Published var isShowMissionBox = false
    @Published var isTapDoneButton = false
    @Published var isDisableDoneButton = false
    
    private var plant: Plant?
    private var dialogues = [Dialogue]()
    private var currentDialogueIndex = 0
    private var currentLineIndex = 0
    
    func setNewPlant(plant: Plant?) {
        self.plant = plant
        
        if let plant = plant {
            getDialogue(plant.characterFileName)
            isShowAddButton = false
            isShowDialogueBox = true
            plantName = plant.character3DFiles[missionDay]
            plantWidth = 350
            
            dialogueText = dialogues[currentDialogueIndex].lines[currentLineIndex]
            currentLineIndex += 1
        }
    }
    
    func setEmptyPot() {
        plantName = "Emptypot.scn"
        missionDay = 0
        plantWidth = 200
        
        dialogueText = ""
        
        isShowDialogueBox = false
        isShowAddButton = true
        isShowMissionBox = false
        isTapDoneButton = false
        isDisableDoneButton = false
        
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
                for row in dataArr[1..<dataArr.count-1] {
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
            plantName = plant.character3DFiles[missionDay]
        }
    }
}
