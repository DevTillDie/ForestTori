//
//  HistoryView.swift
//  ForestTori
//
//  Created by hyebin on 4/27/24.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    
    @Binding var isShowHistoryDetail: Bool
    @Binding var plant: Plant?
    @Binding var selectedHistory: (image: UIImage, record: String)?
    
    var body: some View {
        if let plant = plant {
            ScrollView {
                VStack {
                    Text(plant.mainQuest)
                        .foregroundStyle(.brownPrimary)
                        .font(.titleL)
                    
                    Text(plant.characterName)
                        .foregroundStyle(.greenSecondary)
                        .font(.titleM)
                        .padding(.top, 2)
                    
                    plantView
                        .padding(.top)
                        
                    Text(plant.characterDescription)
                        .foregroundStyle(.gray50)
                        .font(.bodyS)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 4)
                    
                    historyList
                        .padding(.horizontal, 4)
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            .onAppear {
                viewModel.loadHistoryData(plantName: plant.characterName)
            }
        }
    }
}

// MARK: - UI

extension HistoryView {
    private var plantView: some View {
        ZStack {
            if let sceneName = plant?.character3DFiles.last,
               let chapterName = plant?.characterFileName {
                Image(viewModel.setBackgroundImage(chapterName))
                    .resizable()
                    .overlay {
                        PlantPotView(sceneViewName: sceneName)
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width*0.6)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .aspectRatio(1, contentMode: .fill)
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: UIScreen.main.bounds.width*0.6)
            }
        }
    }
    
    private var historyList: some View {
        LazyVStack {
            ForEach(viewModel.plantHistory, id: \.self) { history in
                historyListRow(history)
                    .onTapGesture {
                        if let imageName = history.imageData,
                           let image = UIImage(data: imageName) {
                            selectedHistory = (image, history.text)
                            isShowHistoryDetail = true
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    private func historyListRow(_ history: History) -> some View {
        HStack {
            if let imageName = history.imageData,
               let image = UIImage(data: imageName) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width*0.15)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width*0.15)
            }
            
            VStack(alignment: .leading) {
                Text(history.text)
                    .font(.titleM)
                    .lineLimit(1)
                
                Text(history.date)
                    .font(.caption)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.beigeSecondary, lineWidth: 2)
                .fill(.gray10)
        }
    }
}
