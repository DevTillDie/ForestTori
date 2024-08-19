//
//  ImageCropView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 8/18/24.
//

import SwiftUI
import PhotosUI

struct ImageCropView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: WriteHistoryViewModel
    @GestureState private var isInteracting: Bool = false

    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    @Binding var isShowCropView: Bool
    
    let padding = UIScreen.main.bounds.height / 844
    let yOffset = -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) / 2
    var image: UIImage?
    var onCrop: (UIImage?, Bool) -> Void

    var body: some View {
        NavigationView {
            imageView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.ignoresSafeArea())
                .navigationTitle("이동 및 크기 조절")
                .navigationBarTitleDisplayMode(.inline)
                .preferredColorScheme(.dark)
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        HStack {
                            Button("취소") {
                                dismiss()
                            }

                            Spacer(minLength: 0)

                            Button("선택") {
                                let image = imageView(true).offset(y: yOffset)
                                let img = image.snapshot()
                                onCrop(img, true)
                                isShowCropView = false
                            }
                        }
                        .foregroundColor(.white)
                    }
                }
        }
    }

    @ViewBuilder
    func imageView(_ hideGrids: Bool = false) -> some View {
        GeometryReader {
            let size = $0.size

            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay {
                        GeometryReader { proxy in
                            let rect = proxy.frame(in: .named("CROPVIEW"))

                            Color.clear
                                .onChange(of: isInteracting) { newValue in
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if rect.minX > 0 {
                                            offset.width -= rect.minX
                                        }
                                        if rect.minY > 0 {
                                            offset.height -= rect.minY
                                        }
                                        if rect.maxX < size.width {
                                            offset.width = rect.minX - offset.width
                                        }
                                        if rect.maxY < size.height {
                                            offset.height = rect.minY - offset.height
                                        }
                                    }

                                    if !newValue {
                                        lastStoredOffset = offset
                                    }
                                }
                        }
                    }
                    .frame(width: size.width, height: size.height)
            }
        }
        .scaleEffect(scale)
        .offset(offset)
        .overlay {
            if !hideGrids {
                grids()
            }
        }
        .coordinateSpace(name: "CROPVIEW")
        .gesture(
            DragGesture()
                .updating($isInteracting) { _, out, _  in
                    out = true
                }
                .onChanged { value in
                    let translation = value.translation
                    offset = CGSize(
                        width: translation.width + lastStoredOffset.width,
                        height: translation.height + lastStoredOffset.height
                    )
                }
        )
        .gesture(
            MagnificationGesture()
                .updating($isInteracting) { _, out, _  in
                    out = true
                }
                .onChanged { value in
                    let updatedScale = value + lastScale
                    scale = (updatedScale < 1 ? 1 : updatedScale)
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if scale < 1 {
                            scale = 1
                            lastScale = 0
                        } else {
                            lastScale = scale - 1
                        }
                    }
                }
        )
        .frame(width: 358, height: 358)
        .cornerRadius(0)
    }

    @ViewBuilder
    func grids() -> some View {
        ZStack {
            HStack {
                ForEach(1...8, id: \.self) { _ in
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(width: 1)
                        .frame(maxWidth: .infinity)
                }
            }

            VStack {
                ForEach(1...8, id: \.self) { _ in
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(height: 1)
                        .frame(maxHeight: .infinity)
                }
            }
        }
    }
}

#Preview {
    ImageCropView(isShowCropView: .constant(true), onCrop: { _, _ in
    })
}
