//
//  DataManager.swift
//  ForestTori
//
//  Created by Nayeon Kim on 1/25/24.
//

import Foundation

/// 게임 데이터를 관리하는 클래스
///
/// - chapters: 챕터 정보
class DataManager: ObservableObject {
    @Published var chapters: [Chapter] = []
    @Published var gardenPlants: [GardenPlant] = []
    
    private let backgrounds = ["DefaultBackground","SpringBackground", "SummerBackground", "AutumnBackground", "WinterBackground"]
    
    // UserDefaults에 데이터가 있다면 그 데이터를 읽어오고, 없다면 파일에서 읽어와 UserDefaults에 저장
    init() {
        loadData()
    }
    
    private func loadData() {
        if let chapterData = UserDefaults.standard.data(forKey: "_chaptersData"),
           let decodedChapters = try? JSONDecoder().decode([Chapter].self, from: chapterData),
           let garendData = UserDefaults.standard.data(forKey: "_gardenData"),
           let decodedGardenPlants = try? JSONDecoder().decode([GardenPlant].self, from: garendData) {
            self.chapters = decodedChapters
            self.gardenPlants = decodedGardenPlants
        } else {
            setupChapterData()
            saveDataToUserDefaults()
        }
    }
}

// MARK: - Data Initialization

extension DataManager {
    // chapters 파일을 읽어와 데이터 저장
    private func setupChapterData() {
        if let filePath = Bundle.main.path(forResource: "Chapters", ofType: "tsv") {
            do {
                let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
                var lines = fileContent.components(separatedBy: "\n")
                lines.removeFirst()
                
                for line in lines {
                    let data = line.components(separatedBy: "\t")
                        .map {$0.replacingOccurrences(of: "\\n", with: "\n")}
                        .map {$0.replacingOccurrences(of: "\r", with: "")}
                    
                    if data.count >= 5 {
                        let chapterId = Int(data[0]) ?? 0
                        let chapterTitle = data[1]
                        let chapterDescription = data[2]
                        let lastChapterEnding = data[3]
                        let chapterBackgroundImage = backgrounds[chapterId]
                        let chapterPlants = readChapterPlants(data[4])
                        
                        chapters.append(
                            Chapter(
                                chapterId: chapterId,
                                chapterTitle: chapterTitle,
                                chapterDescription: chapterDescription,
                                lastChapterEnding: lastChapterEnding,
                                chatperBackgroundImage: chapterBackgroundImage,
                                chapterPlants: chapterPlants
                            )
                        )
                    }
                }
            } catch {
                print("Error reading chapter data from file: \(error)")
            }
        } else {
            print("File not found")
        }
    }
    
    // chapter에 해당하는 식물 파일을 읽어옴
    private func readChapterPlants(_ fileName: String) -> [Plant] {
        var plants = [Plant]()
        var prevID = 0
        
        if let filePath = Bundle.main.path(forResource: fileName, ofType: "tsv") {
            do {
                let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
                var lines = fileContent.components(separatedBy: "\n")
                lines.removeFirst()
                
                for line in lines {
                    let data = line.components(separatedBy: "\t")
                        .map {$0.replacingOccurrences(of: "\\n", with: "\n")}
                        .map {$0.replacingOccurrences(of: "\r", with: "")}
                    
                    if data.count >= 12 {
                        let id = Int(data[0]) ?? 0
                        prevID = id
                        let characterName = data[1]
                        let characterImage = data[2]
                        let characterDescription = data[3]
                        let mainQuest = data[4]
                        
                        var missions = [Mission]()
                        if !data[5].isEmpty {
                            missions = data[5].components(separatedBy: "|").map { missionString in
                                let missionData = missionString.components(separatedBy: ":")
                                let day = Int(missionData[0]) ?? 0
                                let content = missionData[1]
                                return Mission(day: day, content: content)
                            }
                        }
                        
                        let characterFileName = data[6]
                        let character3DFiles = data[7].components(separatedBy: "|").map {String($0)}
                        let totalDay = Int(data[8]) ?? 0
                        let characterEnding = data[9]
                        
                        let gardenMessage = data[10]
                        let garden3DFile = data[11]
                        let gardenPositionX = Float(data[12]) ?? 0.0
                        let gardenPositionZ = Float(data[13]) ?? 0.0
                        
                        plants.append(
                            Plant(
                                id: id,
                                characterName: characterName,
                                characterImage: characterImage,
                                characterDescription: characterDescription,
                                mainQuest: mainQuest,
                                missions: missions,
                                characterFileName: characterFileName, 
                                character3DFiles: character3DFiles,
                                totalDay: totalDay,
                                characterEnding: characterEnding
                            )
                        )
                        
                        gardenPlants.append(
                            GardenPlant(
                                id: id,
                                plantName: characterName,
                                gardenMessage: gardenMessage,
                                garden3DFile: garden3DFile,
                                gardenPositionX: gardenPositionX,
                                gardenPositionZ: gardenPositionZ,
                                completeDescription: characterEnding
                            )
                        )
                    }
                }
                
            } catch {
                print("Error reading plant data from file: \(error)")
            }
        } else {
            print("File not found")
        }
        
        return plants
    }
    
    // 파일에서 읽어온 데이터를 UserDefaults에 저장
    private func saveDataToUserDefaults() {
        do {
            let encodedChaptersData = try JSONEncoder().encode(chapters)
            UserDefaults.standard.set(encodedChaptersData, forKey: "_chaptersData")
            
            let encodedGardensData = try JSONEncoder().encode(gardenPlants)
            UserDefaults.standard.set(encodedGardensData, forKey: "_gardenData")
        } catch {
            print("Error encoding chapters: \(error)")
        }
    }
}
