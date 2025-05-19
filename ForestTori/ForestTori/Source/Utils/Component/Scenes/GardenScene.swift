//
//  GardenScene.swift
//  ForestTori
//
//  Created by Nayeon Kim on 4/5/24.
//

import SwiftUI

import SceneKit

struct GardenScene: UIViewRepresentable {
    @Binding var selectedPlant: GardenPlant?
    @Binding var showHistoryView: Bool
    @Binding var dialogueMessage: String
    @Binding var showDialogueBox: Bool
    
    private let lightNode = SCNNode()
    private let sceneView = SCNView()
    
    var groundObject: String
    var chapterPlants: [GardenPlant]?
    var positions: [(x: Float, y: Float, z: Float)]
    var currentChapter: Int
    var isShowBubble: Bool = true
    
    func makeUIView(context: Context) -> some UIView {
        setSceneView()
        
        guard let plants = chapterPlants else {
            return sceneView
        }
                
        for (idx, plant) in plants.enumerated() {
            guard let newNode = addNode(plant: plant, idx: idx) else {
                return sceneView
            }
            sceneView.scene?.rootNode.addChildNode(newNode)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap(_:))
        )
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        return sceneView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let newNode = addFreesia() else { return}
        sceneView.scene?.rootNode.addChildNode(newNode)
        
        if isShowBubble {
            guard let plants = chapterPlants else { return }
            
            for (idx, plant) in plants.enumerated() {
                guard let newNode = addBubbleNode(plant: plant, idx: idx) else { return }
                sceneView.scene?.rootNode.addChildNode(newNode)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        let parent: GardenScene
        
        init(_ parent: GardenScene) {
            self.parent = parent
        }
        
        @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
            let sceneView = gestureRecognize.view as! SCNView
            let touchLocation = gestureRecognize.location(in: sceneView)
            let hitTestResults = parent.sceneView.hitTest(touchLocation, options: nil)
            
            guard let rootNode = hitTestResults.first?.node else { return }
            let currentNode: SCNNode? = rootNode
            
            if let node = currentNode {
                if let selectedName = node.name {
                    if selectedName.contains("bubble") {
                        if let selectedPlant = parent.chapterPlants?.first(where: {
                            selectedName.contains($0.plantName)
                        }) {
                            parent.dialogueMessage = selectedPlant.gardenMessage
                            parent.showDialogueBox = true
                        }
                    } else if let selectedPlant = parent.chapterPlants?.first(where: {
                        $0.plantName.contains(selectedName)
                    }) {
                        parent.selectedPlant =  selectedPlant
                        parent.showHistoryView = true
                    }
                }
            }
        }
    }
}

extension GardenScene {
    private func setSceneView() {
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.light?.intensity = 10000
        lightNode.position = SCNVector3(x: 100, y: 100, z: 100)
        
        sceneView.backgroundColor = .clear
        sceneView.scene = SCNScene(named: groundObject)
        sceneView.scene?.rootNode.scale = SCNVector3(x: 1.0, y: 1.0, z: 1.0)
        
        sceneView.scene?.rootNode.addChildNode(lightNode)
        
        sceneView.pointOfView?.camera?.contrast = -1
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
    
    private func addFreesia() -> SCNNode? {
        let plantNode = SCNNode()
        
        guard let plantScene = SCNScene(named: "Freesia.scn") else {return nil}
        
        for childNode in plantScene.rootNode.childNodes {
            plantNode.addChildNode(childNode)
        }
        
        plantNode.position = SCNVector3(x: Float(3.8), y: Float(1.0), z: Float(-1.0))
        plantNode.scale = SCNVector3(x: 0.8, y: 0.8, z: 0.8)
        
        return plantNode
    }
    
    private func addNode(plant: GardenPlant, idx: Int) -> SCNNode? {
        let plantNode = SCNNode()
        
        guard let plantScene = SCNScene(named: plant.garden3DFile) else {return nil}
        let plantPositionX = positions[idx].x
        let plantPositionY = positions[idx].y
        let plantPositionZ = positions[idx].z
        
        for childNode in plantScene.rootNode.childNodes {
            childNode.name = "\(plant.plantName)"
            plantNode.addChildNode(childNode)
        }
        
        plantNode.position = SCNVector3(x: plantPositionX, y: plantPositionY, z: plantPositionZ)
        plantNode.scale = SCNVector3(x: 1.0, y: 1.0, z: 1.0)
        
        return plantNode
    }
    
    private func addBubbleNode(plant: GardenPlant, idx: Int) -> SCNNode? {
        let plantNode = SCNNode()
        
        guard let plantScene = SCNScene(named: "Bubble.scn") else {return nil}
        let positionX = positions[idx].x
        let positionY = positions[idx].y + 3.2
        let positionZ = positions[idx].z
        
        for childNode in plantScene.rootNode.childNodes {
            childNode.name = "\(plant.plantName)_bubble"
            plantNode.addChildNode(childNode)
        }
        
        plantNode.position = SCNVector3(x: positionX, y: positionY, z: positionZ)
        plantNode.scale = SCNVector3(x: 0.6, y: 0.6, z: 0.6)
        
        return plantNode
    }
}
