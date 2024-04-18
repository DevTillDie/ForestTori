//
//  HistoryView.swift
//  ForestTori
//
//  Created by hyebin on 4/15/24.
//

import SwiftUI

struct HistoryView: View {
    @StateObject var viewModel = HistoryViewModel()
    
    @State private var isShowCustomPopup = false
    @State private var isShowCameraPicker = false
    @State private var isShowPhotoLibraryPicker = false
    
    private let placeHolder = "오늘의 활동과 감정을 적어보세요"
    var plantName: String
    
    var body: some View {
        VStack {
            hisoryViewHeader
            
            selectImageView
                .aspectRatio(4/3, contentMode: .fit)
                .padding(.horizontal)
            
            writeHistoryView
        }
        .fullScreenCover(isPresented: $isShowCameraPicker) {
            ImagePicker(selectedImage: $viewModel.selectedImage, sourceType: .camera)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $isShowPhotoLibraryPicker) {
            ImagePicker(selectedImage: $viewModel.selectedImage, sourceType: .photoLibrary)
        }
        .onAppear {
            viewModel.plantName = plantName
        }
    }
}

// MARK: - UI

extension HistoryView {
    private var hisoryViewHeader: some View {
        HStack {
            Button {
                // TODO: Dismiss
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.redPrimary)
            }
            
            Spacer()
            
            Text("성장일지")
                .font(.subtitleL)
            
            Spacer()
            
            Button {
                viewModel.saveHistory()
            } label: {
                Text("완료")
                    .font(.subtitleM)
                    .foregroundStyle(.greenSecondary)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var selectImageView: some View {
        VStack {
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.gray.opacity(0.2))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
                    .onTapGesture {
                        withAnimation {
                            isShowCustomPopup.toggle()
                        }
                    }
                    .overlay {
                        selectImagePopup
                            .hidden(isShowCustomPopup)
                    }
            }
        }
    }
    
    private var writeHistoryView: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color.gray10)
            .stroke(.brownSecondary, lineWidth: 2)
            .overlay(alignment: .top) {
                TextField(placeHolder, text: $viewModel.todayHistory, axis: .vertical)
                    .tint(.greenSecondary)
                    .padding()
            }
            .padding()
    }
    
    private var selectImagePopup: some View {
        HStack {
            Spacer(minLength: 56)
            
            VStack {
                Button {
                    isShowCameraPicker = true
                }label: {
                    HStack {
                        Text("사진 찍기")
                        Spacer()
                        Image(systemName: "camera")
                            .font(.system(size: 22))
                    }
                }
                
                Divider()
                
                Button {
                    isShowPhotoLibraryPicker = true
                }label: {
                    HStack {
                        Text("사진 선택")
                        Spacer()
                        Image(systemName: "photo")
                            .font(.system(size: 22))
                    }
                }
            }
            .foregroundStyle(.black)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.white)
            )
            
            Spacer(minLength: 56)
        }
    }
}
