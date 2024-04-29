//
//  HistoryDetailView.swift
//  ForestTori
//
//  Created by hyebin on 4/29/24.
//

import SwiftUI

struct HistoryDetailView: View {
    @Binding var isShowHistoryDetailView: Bool
    
    var image: UIImage
    var record: String
    
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
        HStack {
            Button {
                withAnimation {
                    isShowHistoryDetailView = false
                }
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.redPrimary)
            }
            
            Spacer()
            
            Text("성장일지")
                .font(.subtitleL)
            
            Spacer()
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
    
    private var imageView: some View {
        Image(uiImage: image)
            .resizable()
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .aspectRatio(5/3, contentMode: .fit)
            .padding(.horizontal)
    }
    
    private var recordView: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color.gray10)
            .stroke(.brownSecondary, lineWidth: 2)
            .overlay(alignment: .topLeading) {
                Text(record)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .padding(.horizontal)
    }
}
