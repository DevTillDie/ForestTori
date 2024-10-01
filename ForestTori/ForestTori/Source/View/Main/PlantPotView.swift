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
    private let lightNode = SCNNode()
    var sceneViewName: String
    
    func makeUIView(context: Context) -> SCNView {
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.light?.intensity = 2000
        lightNode.position = SCNVector3(x: 100, y: 100, z: 100)
        
        sceneView.backgroundColor = .clear
        sceneView.scene = SCNScene(named: sceneViewName)
        sceneView.scene?.rootNode.name = sceneViewName
        sceneView.scene?.rootNode.scale = SCNVector3(x: 0.8, y: 0.8, z: 0.8)
        
        sceneView.scene?.rootNode.addChildNode(lightNode)
        sceneView.pointOfView?.camera?.contrast = -3
        
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
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.light?.intensity = 2000
        lightNode.position = SCNVector3(x: 100, y: 100, z: 100)
        
        if sceneViewName != scnView.scene?.rootNode.name {
            scnView.scene = SCNScene(named: sceneViewName)
            scnView.scene?.rootNode.scale = SCNVector3(x: 1.0, y: 1.0, z: 1.0)
            scnView.scene?.rootNode.name = sceneViewName
            
            scnView.scene?.rootNode.addChildNode(lightNode)
            scnView.pointOfView?.camera?.contrast = -3
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
