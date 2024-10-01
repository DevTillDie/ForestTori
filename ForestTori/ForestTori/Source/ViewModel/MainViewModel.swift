//
//  TempViewModel.swift
//  ForestTori
//
//  Created by Nayeon Kim on 9/21/24.
//

import SwiftUI

class MainViewModel: ObservableObject {
    @AppStorage("currentTab") var currentTab = 0
    @AppStorage("currentDialogueIndex") var currentDialogueIndex = 0
    @AppStorage("currentLineIndex") var currentLineIndex = 0
    @AppStorage("dialogueText") var dialogueText = ""
    @AppStorage("missionText") var missionText = ""
    @AppStorage("dialogues") var storedDialogues = Data()
    @AppStorage("plantStatuses") private var storedStatuses = Data()
    @AppStorage("totalProgressValue") var totalProgressValue = 0.0
    
    @Published var plantStatuses = [
        0: PlantStatus(),
        1: PlantStatus(),
        2: PlantStatus()
    ] {
        didSet {
            saveStatuses()
        }
    }
    @Published var isCompleteChapter = false
    @Published var isCompleteTodayMission = false {
        didSet {
            if isCompleteTodayMission == true {
                isShowHistoryView = false
                completMission(index: self.currentTab)
                isCompleteTodayMission = false
            }
        }
    }
    @Published var isShowNotAvailable = false
    @Published var isShowEnding = false
    @Published var isShowHistoryView = false
    
    private var dialogues = [Dialogue]()
    private let userName = UserDefaults.standard.value(forKey: "userName") as? String ?? "토리"
    
    init() {
        loadStatuses()
        loadDialogues()
    }
    
    private func startNewChapter() {
        plantStatuses = [
            0: PlantStatus(),
            1: PlantStatus(),
            2: PlantStatus()
        ]
    }
    
    private func resetData() {
        dialogueText = ""
        missionText = ""
        
        currentDialogueIndex = 0
        currentLineIndex = 0
    }
    
    func setNewPlant(plant: Plant) {
        withAnimation(.easeInOut(duration: 0.5)) {
            plantStatuses[currentTab]?.plant = plant
        }
        
        getDialogue(plant.characterFileName)
        saveDialogues()
        
        plantStatuses[currentTab]?.missionStatus = .receivingMission
        
        if currentLineIndex < dialogues[currentDialogueIndex].lines.count {
            dialogueText = dialogues[currentDialogueIndex].lines[currentLineIndex]
        }

        missionText = plant.missions[0].content
    }
    
    func showNextDialogue(index: Int) {
        if currentLineIndex == dialogues[currentDialogueIndex].lines.count {
            plantStatuses[index]?.missionStatus = .inProgress

            if dialogues[currentDialogueIndex].type == "Ending" {
                withAnimation(.easeInOut(duration: 0.5)) {
                    goNextDay(index: index)
                }
            }
        } else {
            dialogueText = dialogues[currentDialogueIndex].lines[currentLineIndex]
            currentLineIndex += 1
        }
    }
    
    func goNextDay(index: Int) {
        if let plant = plantStatuses[index]?.plant {
            if plantStatuses[index]!.missionDay < plant.totalDay - 1 {
                plantStatuses[index]?.missionDay += 1
                
                missionText = plant.missions[plantStatuses[index]!.missionDay].content
                
                if dialogues[currentDialogueIndex + 1].type == "Opening" {
                    currentDialogueIndex += 1
                    currentLineIndex = 0
                    
                    plantStatuses[index]?.missionStatus = .receivingMission
                    
                    showNextDialogue(index: index)
                }
            } else {
                plantStatuses[index]?.missionStatus = .none
                plantStatuses[index]?.completeStory()
                completeCurrentTab()
            }
        }
    }
    
    func completMission(index: Int) {
        currentDialogueIndex += 1
        currentLineIndex = 0
        
        plantStatuses[index]!.progressValue = (Double(plantStatuses[index]!.missionDay + 1)/Double(plantStatuses[index]!.plant?.totalDay ?? 0)) * 100
        totalProgressValue += (1 / Double(plantStatuses[index]!.plant?.totalDay ?? 1)) * 25
        
        plantStatuses[index]!.missionStatus = .completed
        showNextDialogue(index: index)
    }
    
    func completeCurrentTab() {
        resetData()
        
        if currentTab < 2 {
            currentTab += 1
            resetData()
        } else {
            if let fileName =  plantStatuses[currentTab]?.plant?.characterFileName, fileName.contains("Winter") {
                isShowEnding = true
            } else {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isCompleteChapter = true
                }
                startNewChapter()
                currentTab = 0
            }
        }
    }
    
    private func saveStatuses() {
        if let encoded = try? JSONEncoder().encode(plantStatuses) {
            storedStatuses = encoded
        }
    }
    
    private func loadStatuses() {
        if let decoded = try? JSONDecoder().decode([Int: PlantStatus].self, from: storedStatuses) {
            plantStatuses = decoded
        }
    }
    
    private func saveDialogues() {
        if let encoded = try? JSONEncoder().encode(dialogues) {
            storedDialogues = encoded
        }
    }
    
    private func loadDialogues() {
        if let decoded = try? JSONDecoder().decode([Dialogue].self, from: storedDialogues) {
            dialogues = decoded
        }
    }
    
    // tsv 파일에 저장된 식물의 대사를 반환
    private func getDialogue(_ fileName: String) {
        dialogues = [Dialogue]()
        
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
            print("Error reading TSV file")
        }
    }
    
    func showNotAvailableAlert() {
        withAnimation(.easeInOut(duration: 1)) {
            isShowNotAvailable = true
        }
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 1)) {
                self.isShowNotAvailable = false
            }
        }
    }
    
    func openWebsite(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

enum MissionStatus: String, Codable {
    case none             // 미션 없음
    case receivingMission // 미션을 받는 중
    case inProgress       // 미션 하는 중
    case done             // 미션 완료
    case completed        // 식물일지 작성까지 완료
}

struct PlantStatus: Codable {
    var plant: Plant?
    var isStoryCompleted = false
    var missionStatus: MissionStatus = .none
    var missionDay = 0
    var progressValue = 0.0
    
    mutating func completeStory() {
        isStoryCompleted = true
    }
}
