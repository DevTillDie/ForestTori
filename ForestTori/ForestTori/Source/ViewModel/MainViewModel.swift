//
//  MainViewModel.swift
//  ForestTori
//
//  Created by hyebin on 2/17/24.
//

import SwiftUI

class MainViewModel: ObservableObject {
    @Published var dialogues = [Dialogue]()
    
    // csv 파일에 저장된 식물의 대사를 반환
    func getDialogue(_ fileName: String) {
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
                        .map {$0.replacingOccurrences(of: "userName", with: "닉네임")}
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
}
