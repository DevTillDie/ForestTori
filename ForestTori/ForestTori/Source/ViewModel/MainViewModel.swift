//
//  TempViewModel.swift
//  ForestTori
//
//  Created by Nayeon Kim on 9/21/24.
//

import SwiftUI

class MainViewModel: ObservableObject {
    @AppStorage("currentChapter") var currentChapter = 1
    @AppStorage("currentTab") var currentTab = 0
    @AppStorage("currentDialogueIndex") var currentDialogueIndex = 0
    @AppStorage("currentLineIndex") var currentLineIndex = 0
    @AppStorage("dialogueText") var dialogueText = ""
    @AppStorage("missionText") var missionText = ""
    @AppStorage("previousMissionText") var previousMissionText = ""
    @AppStorage("dialogues") var storedDialogues = Data()
    @AppStorage("plantStatuses") private var storedStatuses = Data()
    @AppStorage("canPerformMission") var canPerformMission = true
    @AppStorage("lastMissionDate") var lastMissionDate = ""
    @AppStorage("isCompletePlant") var isCompletePlant = false
    
    @Published var plantStatuses = [PlantStatus(), PlantStatus(), PlantStatus()] {
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
    @Published var isShowNotAvailableToMove = false
    @Published var isShowNotAvailableToSelect = false
    @Published var isShowEnding = false
    @Published var isShowHistoryView = false
    @Published var navigateToGarden = false
    
    private var dialogues = [Dialogue]()
    private var timer: Timer?
    private let userName = UserDefaults.standard.value(forKey: "userName") as? String ?? ""
    
    init() {
        loadStatuses()
        loadDialogues()
        checkMissionAvailability()
        startTimerToCheckDate()
    }
    
    private func startNewChapter() {
        plantStatuses = [PlantStatus(), PlantStatus(), PlantStatus()]
    }
    
    private func resetData() {
        dialogueText = ""
        missionText = ""
        previousMissionText = ""
        
        currentDialogueIndex = 0
        currentLineIndex = 0
    }
    
    func setNewPlant(plant: Plant) {
        plantStatuses[currentTab].plant = plant
        
        getDialogue(plant.dialogueFile)
        saveDialogues()
        
        plantStatuses[currentTab].missionStatus = .receivingMission
        
        if currentLineIndex < dialogues[currentDialogueIndex].lines.count {
            dialogueText = dialogues[currentDialogueIndex].lines[currentLineIndex]
        }
        
        missionText = plant.missions[0].content
    }
    
    func showNextDialogue(index: Int) {
            if currentLineIndex == dialogues[currentDialogueIndex].lines.count {
                plantStatuses[index].missionStatus = .inProgress
                
                if dialogues[currentDialogueIndex].type == "Ending" {
                    let today = Date().toString()
                    lastMissionDate = today
                    canPerformMission = false
                    
                    goNextDay(index: index)
                }
            } else {
                dialogueText = dialogues[currentDialogueIndex].lines[currentLineIndex]
                currentLineIndex += 1
            }
        }
        
        func goNextDay(index: Int) {
            if let plant = plantStatuses[index].plant {
                if plantStatuses[index].missionDay < plant.totalDay - 1 {
                    plantStatuses[index].missionDay += 1
                    
                    previousMissionText = missionText
                    missionText = plant.missions[plantStatuses[index].missionDay].content
                    
                    if dialogues[currentDialogueIndex + 1].type == "Opening" {
                        currentDialogueIndex += 1
                        currentLineIndex = 0
                        
                        plantStatuses[index].missionStatus = .receivingMission
                    }
                } else {
                    plantStatuses[index].missionStatus = .none
                    plantStatuses[index].completeStory()
                    completeCurrentTab()
                }
            }
        }
    
    func completMission(index: Int) {
        currentDialogueIndex += 1
        currentLineIndex = 0
        
        plantStatuses[index].progressValue = (Double(plantStatuses[index].missionDay + 1)/Double(plantStatuses[index].plant?.totalDay ?? 0)) * 100
        
        plantStatuses[index].missionStatus = .completed
        showNextDialogue(index: index)
    }
    
    func completeCurrentTab() {
        resetData()
        
        if currentTab < 2 {
            withAnimation(.easeInOut(duration: 0.5)) {
                isCompletePlant = true
            }
        } else {
            if let fileName =  plantStatuses[currentTab].plant?.dialogueFile, fileName.contains("Winter") {
                isShowEnding = true
            } else {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isCompleteChapter = true
                }
                startNewChapter()
                currentChapter += 1
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
        if let decoded = try? JSONDecoder().decode([PlantStatus].self, from: storedStatuses) {
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
    
    func checkMissionAvailability() {
        let today = Date().toString()
        if today > lastMissionDate {
            self.canPerformMission = true
        }
    }
    
    func startTimerToCheckDate() {
        DispatchQueue.global(qos: .background).async {
            let timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
                self?.checkMissionAvailability()
            }
            
            RunLoop.current.add(timer, forMode: .common)
            RunLoop.current.run()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func showNotAvailableToMoveAlert() {
        withAnimation(.easeInOut(duration: 1)) {
            isShowNotAvailableToMove = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 1)) {
                self.isShowNotAvailableToMove = false
            }
        }
    }
    
    func showNotAvailableToSelectAlert() {
        withAnimation(.easeInOut(duration: 1)) {
            isShowNotAvailableToSelect = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 1)) {
                self.isShowNotAvailableToSelect = false
            }
        }
    }
    
    func shouldHideDialogueBox(for index: Int) -> Bool {
        let status = plantStatuses[index].missionStatus
        
        return status == .receivingMission || (status == .completed && canPerformMission) || (status == .inProgress && !canPerformMission)
    }
    
    func checkMissionBox(for index: Int) -> Bool {
        let status = plantStatuses[index].missionStatus
        
        return status == .done || status == .completed || (status == .inProgress && !canPerformMission)
    }
    
    func openWebsite(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    @MainActor 
    func setNotification() {
        // 미션을 수행할 수 있는 경우
        if canPerformMission {
            // 식물을 선택한 경우
            if GameManager.instance.isPlantSelected {
                if let newPlantName = GameManager.instance.user.selectedPlant?.name {
                    let line = "\(newPlantName)이 토리를 기다리고 있어요:)\n오늘 미션을 수행해서 \(newPlantName)을 키워보아요!"
                    NotificationManager.instance.scheduleNotification(line: line)
                }
            // 식물을 선택하지 않은 경우
            } else {
                let line = "새 식물이 토리를 기다리고 있어요:)\n화분에 새 식물을 심어보아요!"
                NotificationManager.instance.scheduleNotification(line: line)
            }
        // 미션을 수행할 수 없는 경우(오늘 플레이를 마친 경우) -> 알림 없음
        } else {
            NotificationManager.instance.removeNotification()
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
