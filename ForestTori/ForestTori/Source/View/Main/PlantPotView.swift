//
//  PlantPotView.swift
//  ForestTori
//
//  Created by hyebin on 2/15/24.
//

import SwiftUI

import SceneKit

struct PlantPotView: UIViewRepresentable {
    private let sceneView = SCNView()
    var sceneViewName: String
    
    func makeUIView(context: Context) -> SCNView {
        sceneView.backgroundColor = .clear
        sceneView.scene = SCNScene(named: sceneViewName)
        sceneView.scene?.rootNode.name = sceneViewName
        sceneView.scene?.rootNode.scale = SCNVector3(x: 0.8, y: 0.8, z: 0.8)
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        sceneView.defaultCameraController.maximumVerticalAngle = 30
       
        // UIPanGestureRecognizer를 제외한 모든 gesture 비활성화
        if let gestureRecognizers = sceneView.gestureRecognizers {
            for gestureRecognizer in gestureRecognizers where !(gestureRecognizer is UIPanGestureRecognizer) {
                gestureRecognizer.isEnabled = false
            }
        }
        
        return sceneView
    }
    
    func updateUIView(_ scnView: SCNView, context: Context) {
        if sceneViewName != scnView.scene?.rootNode.name {
            scnView.scene = SCNScene(named: sceneViewName)
            scnView.scene?.rootNode.scale = SCNVector3(x: 1, y: 1, z: 1)
            scnView.scene?.rootNode.name = sceneViewName
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        let parent: PlantPotView
        
        init(_ parent: PlantPotView) {
            self.parent = parent
        }
    }
}
