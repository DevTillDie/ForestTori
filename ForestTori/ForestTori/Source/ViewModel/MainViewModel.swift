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

enum MissionStatus: String, Codable {
    case none             // 미션 없음
    case receivingMission // 미션을 받는 중
    case inProgress       // 미션 하는 중
    case done             // 미션 완료
    case completed        // 식물일지 작성까지 완료
}

class MainViewModel: ObservableObject {
    @AppStorage("missionDay") var missionDay = 0
    @AppStorage("currentDialogueIndex") var currentDialogueIndex = 0
    @AppStorage("progressValue") var progressValue = 0.0
    @AppStorage("totalProgressValue") var totalProgressValue = 0.0
    @AppStorage("missionStatus") var missionStatus: MissionStatus = .none
    
    @Published var plant3DFileName = "Emptypot.scn"
    @Published var plantWidth: CGFloat = 250
    
    @Published var dialogueText = ""
    @Published var missionText = ""
    
    @Published var isShowHistoryView = false
    @Published var isCompleteMission = false
    @Published var isShowCompleteMissionView = false
    
    @Published var isCompleteTodayMission = false {
        didSet {
            if isCompleteTodayMission == true {
                isShowHistoryView = false
                completMission()
                isCompleteTodayMission = false
            }
        }
    }
    
    @Published var showEnding = false
    @Published var plantName = ""
    
    private var plant: Plant?
    private var dialogues = [Dialogue]()
    private var currentLineIndex = 0
    private let userName = UserDefaults.standard.value(forKey: "userName") as? String ?? "토리"
    
    func setNewPlant(plant: Plant?) {
        self.plant = plant
        
        if let plant = plant {
            getDialogue(plant.characterFileName)
            
            plant3DFileName = plant.character3DFiles[missionDay]
            plantWidth = 350
            plantName = plant.characterName
            
            if missionStatus == .none {
                missionStatus = .receivingMission
            }
            
            if currentLineIndex < dialogues[currentDialogueIndex].lines.count {
                dialogueText = dialogues[currentDialogueIndex].lines[currentLineIndex]
            }

            missionText = plant.missions[missionDay].content
        }
    }
    
    func setEmptyPot() {
        plant3DFileName = "Emptypot.scn"
        missionDay = 0
        plantWidth = 200
        progressValue = 0.0
        plantName = ""
        
        dialogueText = ""
        missionText = ""
        
        missionStatus = .none
        isCompleteMission = false
        
        currentDialogueIndex = 0
        currentLineIndex = 0
    }
    
    func showNextDialogue() {
        if currentLineIndex == dialogues[currentDialogueIndex].lines.count {
            missionStatus = .inProgress

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
        progressValue = (Double(missionDay + 1)/Double(plant?.totalDay ?? 0)) * 100
        totalProgressValue += (1 / Double(plant?.totalDay ?? 1)) * 25
        
        missionStatus = .completed
        showNextDialogue()
    }
    
    // csv 파일에 저장된 식물의 대사를 반환
    private func getDialogue(_ fileName: String) {
        dialogues = []
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: "tsv") else {
            return
        }
        
        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            
            if let dataArr = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: "\t")}) {
                for row in dataArr[1..<dataArr.count] where row.count >= 3 {
                    let lines = Array(row[3...])
                        .map {$0.replacingOccurrences(of: "(userName)", with: userName)}
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
    }
    
    private func nextDay() {
        missionDay += 1

        if let plant = plant {
            if missionDay == plant.totalDay {
                if plant.characterFileName.contains("Winter") {
                    showEnding = true
                } else {
                    isCompleteMission = true
                    missionStatus = .none
                }
            } else {
                plant3DFileName = plant.character3DFiles[missionDay]
                missionText = plant.missions[missionDay].content
                
                if dialogues[currentDialogueIndex + 1].type == "Opening" {
                    currentDialogueIndex += 1
                    currentLineIndex = 0
                    
                    missionStatus = .receivingMission
                    showNextDialogue()
                }
            }
        }
    }
}
