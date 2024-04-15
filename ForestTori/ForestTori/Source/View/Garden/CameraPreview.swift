//
//  CameraPreview.swift
//  ForestTori
//
//  Created by Nayeon Kim on 4/15/24.
//

import SwiftUI

import ARKit
import RealityKit

struct CameraPreview: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
            let view = ARView()
            let session = view.session
            let config = ARWorldTrackingConfiguration()
            config.isLightEstimationEnabled = true

            config.planeDetection = [.horizontal]
            session.run(config)
        
            return view
        }
    
    func updateUIView(_ uiView: ARView, context: Context) { }
}
