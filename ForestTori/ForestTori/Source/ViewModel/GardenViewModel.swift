//
//  GardenViewModel.swift
//  ForestTori
//
//  Created by hyebin on 9/3/24.
//

import SwiftUI

class GardenViewModel: ObservableObject {
    @Published var isShowNoPlantBox = false {
        didSet {
            if isShowNoPlantBox {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isShowNoPlantBox = false
                }
            }
        }
    }
    
    @Published var isShowNotChapterBox = false {
        didSet {
            if isShowNotChapterBox {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isShowNotChapterBox = false
                }
            }
        }
    }
    
    @Published var dialogueMessage = ""
    
    let chapter = ["", "봄", "여름", "가을", "겨울"]
    let backgroundImages = ["DefaultBackground", "SpringBackground", "SummerBackground", "AutumnBackground", "WinterBackground"]
    let chapterTitle = ["", "봄, 숲을 만나다", "여름, 안녕? 토리야", "가을, 꿈의 형태", "겨울, 새로운 봄을 기다리며"]
    let groundObjects = ["Gardenground.scn", "Gardenground_Spring.scn", "Gardenground_Summer.scn", "Gardenground_Autumn.scn", "Gardenground_Winter.scn"]
    let positions: [[(x: Float, y: Float, z: Float)]] = [
        [],
        [(-2.6, 0.5, 3.4), (1.2, 0.5, 2), (-1, 0.5, -2.3)],
        [(0.2, 0.5, -3.3), (-2.9, 0.5, 1.3), (1.2, 0.5, 2.8)],
        [(1.3, 0.5, -2.2), (-2.1, 0.5, -3), (-1, 0.5, -2.8)],
        [(-1.6, 0.5, 2.7), (-3.3, 0.5, 0.8), (-0.5, 0.5, -3.1)]
    ]
}
