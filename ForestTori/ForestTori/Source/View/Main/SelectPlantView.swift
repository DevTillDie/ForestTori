//
//  SelectPlantView.swift
//  ForestTori
//
//  Created by hyebin on 2/21/24.
//

import SwiftUI

struct TestPlantModel: Identifiable {
    var id: Int
    var plantName: String
    var plantMission: String
    var plantImage: String
    var plantDescription: String
}

struct SelectPlantView: View {
    @State private var currentIndex = 0
    
    @Binding var isShowSelectPlantView: Bool
    
    private let plants: [TestPlantModel] = [
        TestPlantModel(id: 0, plantName: "민들레씨", plantMission: "매일 창문 30분 열어 환기하기", plantImage: "PlantSelect_Spring1", plantDescription: "겁이 많은 민들레씨들이 하늘로 날아가지 못하고 있어요. 용기를 낼 수 있게 매일 창문을 열어 민들레씨들을 도와줄래요?"),
        TestPlantModel(id: 1, plantName: "???", plantMission: "???", plantImage: "PlantSelect_Spring2", plantDescription: "추후 공개예정"),
        TestPlantModel(id: 2, plantName: "???", plantMission: "???", plantImage: "PlantSelect_Spring3", plantDescription: "추후 공개예정"),
        TestPlantModel(id: 3, plantName: "???", plantMission: "???", plantImage: "PlantSelect_Spring4", plantDescription: "추후 공개예정"),
    ]
    
    var body: some View {
        PlantCarousel(index: $currentIndex, plants: plants) { plant in
            GeometryReader { proxy in
                let width = proxy.size.width
                let height = proxy.size.height/2
                let offset = currentIndex == plant.id ? 1 : 0.8
                let spacing: CGFloat = 16
                
                VStack {
                    Text("식물 친구를 선택해주세요")
                        .font(.titleM)
                        .foregroundColor(.white)
                        .padding(.bottom, 16)
                    
                    PlantCardView(
                        isShowSelectPlantView: $isShowSelectPlantView,
                        plant: plant
                    )
                        .frame(width: width, height: height * offset + spacing)
                        .fixedSize()
                }
                .position(x: width/2, y: height)
            }
        }
    }
}

struct PlantCarousel<Content: View, T: Identifiable>: View {
    @GestureState var offset: CGFloat = 0
    @State private var currentIndex = 0
    
    @Binding var index: Int
    
    private let spacing: CGFloat = 22
    private let trailingSpace: CGFloat = 80
    
    var content: (T) -> Content
    var plants: [T]
    
    init(index: Binding<Int>, plants: [T], @ViewBuilder content: @escaping (T) -> Content) {
        self.plants = plants
        self._index = index
        self.content = content
    }
    
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustMentWidh = (trailingSpace/2) - spacing
            
            HStack(spacing: spacing) {
                ForEach(plants) { item in
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: (CGFloat(currentIndex) * -width) +  adjustMentWidh  + offset)
            .gesture(
                DragGesture()
                    .updating($offset) { value, out, _ in
                        out = value.translation.width
                    }
                    .onEnded { value in
                        let offsetX = value.translation.width
                        let progress = -offsetX/width
                        let roundIndex = progress.rounded()
                        
                        currentIndex = max(min(currentIndex+Int(roundIndex), plants.count-1), 0)
                        
                        currentIndex = index
                    }
                    .onChanged { value in
                        let offsetX = value.translation.width
                        let progress = -offsetX/width
                        let roundIndex = progress.rounded()
                        
                        index = max(min(currentIndex+Int(roundIndex), plants.count-1), 0)
                    }
            )
        }
        .animation(.easeInOut, value: offset == 0)
    }
}

#Preview {
    MainView()
}
