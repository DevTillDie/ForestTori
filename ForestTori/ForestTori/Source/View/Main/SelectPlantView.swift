//
//  SelectPlantView.swift
//  ForestTori
//
//  Created by hyebin on 2/21/24.
//

import SwiftUI

struct SelectPlantView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var mainViewModel: MainViewModel
    
    @State private var currentIndex = 0
    @Binding var isShowSelectPlantView: Bool
    
    var body: some View {
        ZStack {
            if isShowSelectPlantView {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isShowSelectPlantView = false
                        }
                    }
                    .transition(.opacity)
                
                Text("식물 친구를 선택해주세요")
                    .font(.titleM)
                    .foregroundColor(.white)
                    .padding(.top, 160)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .transition(.move(edge: .bottom))
                
                PlantCarousel(index: $currentIndex, plants: gameManager.chapter.chapterPlants) { plant in
                    GeometryReader { proxy in
                        let width = proxy.size.width
                        let height = proxy.size.height/2
                        let offset = currentIndex == plant.id-1 ? 1 : 0.8
                        let spacing: CGFloat = 16
                        
                        PlantCardView(
                            isShowSelectPlantView: $isShowSelectPlantView,
                            plant: plant
                        )
                        .environmentObject(gameManager)
                        .environmentObject(mainViewModel)
                        .frame(width: width, height: height * offset + spacing)
                        .position(x: width/2, y: height)
                    }
                }
                .transition(.move(edge: .bottom))
            }
        }
    }
}

// MARK: Plant Carousel View
//
//  - offset: drag Gesture value
//  - currentIndex: 가운데 보여지는 식물의 인덱스
//  - index: drag Gesture의 값에 따라 현재 인덱스를 계산하기 위한 변수
//  - spacing: 다음 뷰와의 거리, 피그마 기준으로 22로 설정
//  - horizontalSpace: 현재 가운데에 있는 뷰의 양 옆 padding 값

struct PlantCarousel<Content: View, T: Identifiable>: View {
    @GestureState var offset: CGFloat = 0
    @State private var currentIndex = 0
    
    @Binding var index: Int
    
    private let spacing: CGFloat = 22
    private let horizontalSpace: CGFloat = 100
    
    var content: (T) -> Content
    var plants: [T]
    
    init(index: Binding<Int>, plants: [T], @ViewBuilder content: @escaping (T) -> Content) {
        self.plants = plants
        self._index = index
        self.content = content
    }
    
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width - (horizontalSpace - spacing)
            let adjustMentWidh = (horizontalSpace / 2) - spacing
            
            HStack(spacing: spacing) {
                ForEach(plants) { item in
                    content(item)
                        .frame(width: proxy.size.width - horizontalSpace)
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: (CGFloat(currentIndex) * -width) +  adjustMentWidh  + offset)
            .gesture(
                DragGesture()
                    .updating($offset) { value, out, _ in
                        out = value.translation.width
                    }
                    .onEnded { _ in
                        currentIndex = index
                    }
                    .onChanged { value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        
                        index = max(min(currentIndex + Int(roundIndex), plants.count - 1), 0)
                    }
            )
        }
        .animation(.easeInOut, value: offset == 0)
    }
}

#Preview {
    SelectPlantView(isShowSelectPlantView: .constant(true))
        .environmentObject(GameManager())
        .environmentObject(ServiceStateViewModel())
}
