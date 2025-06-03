//
//  PermissionManager.swift
//  ForestTori
//
//  Created by Nayeon Kim on 5/24/25.
//

import Foundation
import PhotosUI

class MediaPermissionManager: ObservableObject {
    
    static let instance = MediaPermissionManager()
    private init() { }
    
    // 카메라 권한 요청
    @MainActor
    func requestCameraPermission() async {
        let granted = await withCheckedContinuation { continuation in
            AVCaptureDevice.requestAccess(for: .video) { granted in
                continuation.resume(returning: granted)
            }
        }
        print("Camera: permission \(granted ? "granted" : "denied")")
    }
    
    // 사진 권한 요청
    @MainActor
    func requestPhotosPermission() async {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        switch status {
        case .authorized, .limited:
            print("Photos: permission granted")
        case .denied, .restricted, .notDetermined:
            print("Photos: permission denied")
        @unknown default:
            print("Photos: permission unknown")
        }
    }
}
