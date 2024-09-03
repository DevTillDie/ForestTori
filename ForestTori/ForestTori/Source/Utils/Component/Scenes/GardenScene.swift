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
    
    private let gardenObject = "Gardenground.scn"
    private let lightNode = SCNNode()
    private let sceneView = SCNView()
    var chapterPlants: [GardenPlant]?
    var currentChapter: Int
    
    func makeUIView(context: Context) -> some UIView {
        setSceneView()
        
        guard let plants = chapterPlants else {
            return sceneView
        }
                
        for plant in plants {
            guard let newNode = addNode(plant: plant) else {
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
        // TODO: 대사 박스 조건 추가
        guard let plants = chapterPlants else { return }
                
        for plant in plants {
            guard let newNode = addBubbleNode(plant: plant) else { return }
            sceneView.scene?.rootNode.addChildNode(newNode)
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
            
            if let hitNode = hitTestResults.first?.node {
                if let selectedName = hitNode.name, selectedName.contains("bubble") {
                    if let selectedPlant = parent.chapterPlants?.first(where: {
                        selectedName.contains($0.plantName)
                    }) {
                        parent.dialogueMessage = selectedPlant.gardenMessage
                        parent.showDialogueBox = true
                    }
                }
                
                if let selectedName = hitNode.geometry?.name {
                    if let selectedPlant = parent.chapterPlants?.first(where: {
                        $0.garden3DFile.lowercased().contains(selectedName)
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
        sceneView.scene = SCNScene(named: gardenObject)
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
    
    private func addNode(plant: GardenPlant) -> SCNNode? {
        let plantNode = SCNNode()
        
        guard let plantScene = SCNScene(named: plant.garden3DFile) else {return nil}
        let plantPositionX = plant.gardenPositionX
        let plantPositionY = plant.gardenPositionY
        let plantPositionZ = plant.gardenPositionZ
        
        for childNode in plantScene.rootNode.childNodes {
            plantNode.addChildNode(childNode)
        }
        
        plantNode.position = SCNVector3(x: plantPositionX, y: plantPositionY, z: plantPositionZ)
        plantNode.scale = SCNVector3(x: 1.0, y: 1.0, z: 1.0)
        
        return plantNode
    }
    
    private func addBubbleNode(plant: GardenPlant) -> SCNNode? {
        let plantNode = SCNNode()
        
        guard let plantScene = SCNScene(named: "Bubble.scn") else {return nil}
        let positionX = plant.gardenPositionX
        let positionY = plant.gardenPositionY + 2.8
        let positionZ = plant.gardenPositionZ
        
        for childNode in plantScene.rootNode.childNodes {
            childNode.name = "\(plant.plantName)_bubble"
            plantNode.addChildNode(childNode)
        }
        
        plantNode.position = SCNVector3(x: positionX, y: positionY, z: positionZ)
        plantNode.scale = SCNVector3(x: 0.6, y: 0.6, z: 0.6)
        
        return plantNode
    }
}
