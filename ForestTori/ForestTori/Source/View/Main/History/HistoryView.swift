//
//  HistoryView.swift
//  ForestTori
//
//  Created by hyebin on 4/15/24.
//

import SwiftUI

struct HistoryView: View {
    @StateObject var viewModel = HistoryViewModel()
    @FocusState private var isFocused: Bool
    
    @State private var isShowCameraPicker = false
    @State private var isShowPhotoLibraryPicker = false
    
    @Binding var isComplete: Bool
    @Binding var isShowHistoryView: Bool
    @Binding var isTapDoneButton: Bool

    private let placeHolder = "오늘의 활동과 감정을 적어보세요"
    
    var body: some View {
        VStack {
            hisoryViewHeader
            
            selectImageView
                .aspectRatio(5/3, contentMode: .fit)
                .padding(.horizontal)
            
            writeHistoryView
        }
        .fullScreenCover(isPresented: $isShowCameraPicker) {
            ImagePicker(selectedImage: $viewModel.selectedImage, sourceType: .camera)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $isShowPhotoLibraryPicker) {
            ImagePicker(selectedImage: $viewModel.selectedImage, sourceType: .photoLibrary)
                .ignoresSafeArea()
        }
        .onTapGesture {
            isFocused = false
        }
    }
}

// MARK: - UI

extension HistoryView {
    private var hisoryViewHeader: some View {
        HStack {
            Button {
                withAnimation {
                    isShowHistoryView = false
                    isTapDoneButton = false
                }
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
                isComplete = true
            } label: {
                Text("완료")
                    .font(.subtitleM)
                    .foregroundStyle(viewModel.isCompleteButtonDisable ? .gray30 : .greenSecondary)
            }
            .disabled(viewModel.isCompleteButtonDisable)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
    
    private var selectImageView: some View {
        VStack {
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.gray.opacity(0.2))
                    selectImagePopup
                }
            }
        }
    }
    
    private var writeHistoryView: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color.gray10)
            .stroke(.brownSecondary, lineWidth: 2)
            .overlay(alignment: .top) {
                TextField(
                    placeHolder,
                    text: Binding(
                        get: {viewModel.todayHistory},
                        set: { newValue, _ in
                            if newValue.lastIndex(of: "\n") != nil {
                                isFocused = false
                            } else {
                                viewModel.todayHistory = newValue
                            }
                        }),
                    axis: .vertical)
                    .focused($isFocused)
                    .submitLabel(.done)
                    .disableAutocorrection(true)
                    .tint(.greenSecondary)
                    .padding()
            }
            .padding(.horizontal)
            .onTapGesture {
                isFocused = true
            }
    }
    
    private var selectImagePopup: some View {
        HStack {
            Spacer(minLength: 56)
            
            VStack {
                Button {
                    isFocused = false
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
                    isFocused = false
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

#Preview {
    MainView()
}
