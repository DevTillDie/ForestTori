//
//  WriteHistoryView.swift
//  ForestTori
//
//  Created by hyebin on 4/15/24.
//

import AVFoundation
import PhotosUI
import SwiftUI

struct WriteHistoryView: View {
    @StateObject var viewModel = WriteHistoryViewModel()
    @EnvironmentObject var keyboardHandler: KeyboardHandler
    @FocusState private var isFocused: Bool
    
    @State private var croppedImage: UIImage?
    @State private var isShowSelectImagePopup = false
    @State private var isShowCameraPicker = false
    @State private var isShowPhotoLibraryPicker = false
    @State private var isShowPermissionAlert = false
    @State private var isShowCropView = false
    @State private var tempSelectedImage: UIImage?
    
    @Binding var isComplete: Bool
    @Binding var isShowHistoryView: Bool
    @Binding var currentStatus: MissionStatus

    private let placeHolder = "오늘의 활동과 감정을 적어보세요"
    private let imageSize = UIScreen.main.bounds.width * 0.92
    var plantName: String
    
    var body: some View {
        VStack {
            hisoryViewHeader
            
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    selectImageView
                        .padding(.horizontal)
                        .padding(.vertical)
                    
                    writeHistoryView
                        .id("writeHistoryView")
                        .onChange(of: isFocused) { focused in
                            if focused {
                                withAnimation {
                                    proxy.scrollTo("writeHistoryView", anchor: .bottom)
                                }
                            }
                        }
                }
            }
        }
        .fullScreenCover(isPresented: $isShowCameraPicker) {
            ImagePicker(selectedImage: $tempSelectedImage,
                        sourceType: .camera)
            .ignoresSafeArea()
            .onAppear {
                isShowSelectImagePopup = false
            }
        }
        .sheet(isPresented: $isShowPhotoLibraryPicker) {
            ImagePicker(selectedImage: $tempSelectedImage,
                        sourceType: .photoLibrary)
            .ignoresSafeArea()
            .onAppear {
                isShowSelectImagePopup = false
            }
        }
        .sheet(isPresented: $isShowCropView) {
            ImageCropView(
                isShowCropView: $isShowCropView,
                image: tempSelectedImage
            ) { croppedImage, isConfirmed in
                if isConfirmed, let croppedImage = croppedImage {
                    viewModel.selectedImage = croppedImage
                }

                tempSelectedImage = nil
                isShowCropView = false
            }
        }
        .alert("사진 혹은 카메라 접근이 허용되어 있지 않습니다. 설정으로 이동하시겠습니까?", isPresented: $isShowPermissionAlert) {
            Button("취소", role: .cancel) {}
            Button("확인") {
                if let url = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        }
        .onChange(of: tempSelectedImage) { newImage in
            if newImage != nil {
                isShowCropView = true
            }
        }
        .onTapGesture {
            isFocused = false
        }
        .onAppear {
            viewModel.plantName = plantName
        }
    }
}

// MARK: - UI

extension WriteHistoryView {
    private var hisoryViewHeader: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("성장일지")
                    .font(.subtitleL)
                
                HStack {
                    Button {
                        withAnimation {
                            isShowHistoryView = false
                            currentStatus = .inProgress
                        }
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.gray40)
                            .frame(height: 40)
                    }
                    
                    Spacer()
                    
                    Button {
                        viewModel.saveHistory()
                        isComplete = true
                    } label: {
                        Text("완료")
                            .font(.subtitleM)
                            .bold()
                            .foregroundStyle(viewModel.isCompleteButtonDisable ? .gray30 : .greenSecondary)
                            .frame(height: 44)
                    }
                    .disabled(viewModel.isCompleteButtonDisable)
                }
                .padding(.horizontal, 16)
            }
            .padding(.top, 8)
            .padding(.bottom, 6)
            
            Rectangle()
                .fill(.gray30)
                .frame(height: 0.5)
        }
    }
    
    private var selectImageView: some View {
        VStack {
            if let image = viewModel.selectedImage {
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 8)
                        )
                        .overlay(alignment: .bottomTrailing) {
                            Button {
                                withAnimation {
                                    isShowSelectImagePopup.toggle()
                                }
                            } label: {
                                Image(systemName: "camera")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.white)
                                    .background {
                                        Circle()
                                            .fill(.gray50)
                                            .scaledToFit()
                                            .padding(-8)
                                    }
                                    .padding()
                            }
                        }
                    
                    if isShowSelectImagePopup {
                        selectImagePopup
                    }
                }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.gray.opacity(0.2))
                    selectImagePopup
                }
            }
        }
        .frame(width: imageSize, height: imageSize)
    }
    
    private var writeHistoryView: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color.gray10)
            .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.width * 0.75)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.brownSecondary, lineWidth: 2)
            }
            .overlay(alignment: .center) {
                VStack {
                ZStack(alignment: .topLeading) {
                    TextEditor(
                        text: Binding(
                            get: {viewModel.todayHistory},
                            set: { newValue, _ in
                                if newValue.lastIndex(of: "\n") != nil {
                                    isFocused = false
                                } else {
                                    viewModel.todayHistory = newValue
                                }
                            })
                    )
                    .padding(-8)
                    Text(placeHolder)
                        .foregroundStyle(viewModel.todayHistory.isEmpty ? .gray30 : .clear)
                        .padding(.horizontal, -4)
                }
                    Text("\(viewModel.todayHistory.count) / 300")
                        .foregroundStyle(.gray30)
                        .onChange(of: viewModel.todayHistory) { newValue in
                            if newValue.count > 300 {
                                viewModel.todayHistory = String(newValue.prefix(300))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                }
                .transparentScrolling()
                .focused($isFocused)
                .submitLabel(.done)
                .disableAutocorrection(true)
                .tint(.greenSecondary)
                .font(.bodyM)
                .foregroundStyle(.gray50)
                .padding()
            }
            .padding(.horizontal)
            .padding(.bottom, 26)
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
                    isShowSelectImagePopup = false
                    if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                        isShowCameraPicker = true
                    } else {
                        isShowPermissionAlert = true
                    }
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
                    isShowSelectImagePopup = false
                    let photoStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
                    if photoStatus == .authorized || photoStatus == .limited {
                        isShowPhotoLibraryPicker = true
                    } else {
                        isShowPermissionAlert = true
                    }
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
    WriteHistoryView(isComplete: .constant(true), isShowHistoryView: .constant(true), currentStatus: .constant(.completed), plantName: "나팔꽃")
}
