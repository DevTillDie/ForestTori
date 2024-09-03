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
    
    let chapter = ["", "봄", "여름", "가을", "겨울"]
    let backgroundImages = ["DefaultBackground", "SpringBackground", "SummerBackground", "AutumnBackground", "WinterBackground"]
    let chapterTitle = ["", "봄, 숲을 만나다", "여름, 안녕? 토리야", "가을, 꿈의 형태", "겨울, 새로운 봄을 기다리며"]
}
