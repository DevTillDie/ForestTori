//
//  GardenScene.swift
//  ForestTori
//
//  Created by Nayeon Kim on 4/5/24.
//

import SwiftUI

import SceneKit

struct GardenScene: UIViewRepresentable {
    @EnvironmentObject var gameManager: GameManager
    
    private let gardenObject = "Gardenground.scn"
    private let lightNode = SCNNode()
    private let sceneView = SCNView()
    
    func makeUIView(context: Context) -> some UIView {
        setSceneView()
        
        // TODO: gameManager 연결
        guard let newNode = addNode() else {
            return sceneView
        }
        sceneView.scene?.rootNode.addChildNode(newNode)
        
        return sceneView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        let parent: GardenScene
        
        init(_ parent: GardenScene) {
            self.parent = parent
        }
    }
}

extension GardenScene {
    private func setSceneView() -> Void {
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.light?.intensity = 10000
        lightNode.position = SCNVector3(x: 100, y: 100, z: 100)
        
        sceneView.backgroundColor = .clear
        sceneView.scene = SCNScene(named: gardenObject)
        sceneView.scene?.rootNode.scale = SCNVector3(x: 1.0, y: 1.0, z: 1.0)
        
        sceneView.scene?.rootNode.addChildNode(lightNode)
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        sceneView.defaultCameraController.maximumVerticalAngle = 30
        
        // UIPanGestureRecognizer를 제외한 모든 gesture 비활성화
        if let gestureRecognizers = sceneView.gestureRecognizers {
            for gestureRecognizer in gestureRecognizers where !(gestureRecognizer is UIPanGestureRecognizer) {
                gestureRecognizer.isEnabled = false
            }
        }
    }
    
    private func addNode() -> SCNNode? {
        let plantNode = SCNNode()
        
        guard let plantScene = SCNScene(named: "Dandelion3.scn") else {
            return nil
        }
        
        let node = SCNNode()
        
        for childNode in plantScene.rootNode.childNodes {
            node.addChildNode(childNode)
        }
        
        node.position = SCNVector3(x: 0.0, y: 1.0, z: 0.0)
        node.scale = SCNVector3(x: 0.8, y: 0.8, z: 0.8)
        
        plantNode.addChildNode(node)
        
        return plantNode
    }
}
