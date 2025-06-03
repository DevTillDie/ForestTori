//
//  CameraPreview.swift
//  ForestTori
//
//  Created by Nayeon Kim on 4/15/24.
//

import SwiftUI

import ARKit
import RealityKit
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    
    @Binding var isCameraDenied: Bool
    
    func makeUIView(context: Context) -> ARView {
        let view = ARView()
        
        if !isCameraDenied {
            let session = view.session
            let config = ARWorldTrackingConfiguration()
            config.isLightEstimationEnabled = true
            
            config.planeDetection = [.horizontal]
            session.run(config)
            
            return view
        }
        
        return view
    }
    
    func updateUIView(_ uiView: ARView, context: Context) { }
}
