//
//  HistoryDetailView.swift
//  ForestTori
//
//  Created by hyebin on 4/29/24.
//

import SwiftUI

struct HistoryDetailView: View {
    @Binding var selectedHistoryIndex: Int?
    @Binding var isShowHistoryDetailView: Bool
    @Binding var selectedHistory: (image: UIImage, date: String, record: String)?
    
//    var image: UIImage
//    var record: String
    
    var body: some View {
        VStack {
            viewHeader
            
            imageView
            
            recordView
        }
    }
}

// MARK: - UI

extension HistoryDetailView {
    private var viewHeader: some View {
        VStack {
            HStack {
                Button {
                    withAnimation {
                        selectedHistoryIndex = nil
                        isShowHistoryDetailView = false
                    }
                } label: {
                    Text(Image(systemName: "chevron.backward"))
                        .bold()
                        .foregroundStyle(.gray40)
                }
                
                Spacer()
                
                Text(selectedHistory?.date ?? "0000.00.00")
                    .font(.subtitleL)
                
                Spacer()
                
            }
            .padding(.horizontal, 8)
            .padding(.top, 11)
            .padding(.bottom, 6)
            
            Rectangle()
                .fill(.gray30)
                .frame(height: 0.33)
        }
    }
    
    private var imageView: some View {
        Image(uiImage: selectedHistory?.image ?? .onboardingFrezia)
            .resizable()
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .aspectRatio(1, contentMode: .fill)
            .padding(.horizontal)
            .padding(.vertical)
    }
    
    private var recordView: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color.gray10)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.brownSecondary, lineWidth: 2)
            }
            .overlay(alignment: .topLeading) {
                Text(selectedHistory?.record.splitCharacter() ?? "내용 없음")
                    .font(.bodyM)
                    .foregroundStyle(.gray50)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .padding(.horizontal)
    }
}
