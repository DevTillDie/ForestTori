//
//  ARView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 4/14/24.
//

import SwiftUI

struct GardenARView: View {
    @Environment(\.presentationMode) var presentationMode
    
    private var backButtonLabel = "돌아가기"
    private var backButtonImage = "chevron.backward"
    private var cameraButtomImage = "button.programmable"
    
    var body: some View {
        ZStack {
            ARView
            
            VStack {
                Spacer()
                
                cameraButtomBar
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}

extension GardenARView {
    @ViewBuilder private var ARView: some View {
        ZStack {
            Color.black
            
            CameraPreview()
            
            GardenScene()
                .scaledToFit()
        }
    }
}

extension GardenARView {
    @ViewBuilder private var cameraButtomBar: some View {
        ZStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: backButtonImage)
                    Text(backButtonLabel)
                    
                    Spacer()
                }
                .foregroundColor(.white)
                .font(.subtitleM)
                .padding(.horizontal, 30)
            }
            
            Button {
                if let image = captureScreen() {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
            } label: {
                ZStack {
                    Image(systemName: cameraButtomImage)
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 70, height: 70)
                        .padding(.vertical, 36)
                }
            }
        }
        .background(.black)
    }
}

extension GardenARView {
    func captureScreen() -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 200)
        
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return nil }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return capturedImage
    }
}

#Preview {
    GardenARView()
}
