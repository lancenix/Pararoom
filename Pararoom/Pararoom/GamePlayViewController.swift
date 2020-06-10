//
//  GamePlayViewController.swift
//  Pararoom
//
//  Created by Rommy Julius Dwidharma on 10/06/20.
//  Copyright © 2020 Maria Jeffina. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class GamePlayViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var recommendationViewContainer: UIView!
    @IBOutlet weak var npcViewController: UIView!
    
    @IBOutlet weak var npcImage: UIImageView!
    @IBOutlet weak var nextButtonImage: UIImageView!
    @IBOutlet weak var prevButtonImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
    var convArray = ["Well… Well… Well… \n Look Who’s Here!!!", "I can see you’re trapped, I know a way how to escape but there is one condition...", "That is if you help me find a soul fragment to revive my friend... I'll help you escape!!", "You can find the soul fragment by interacting from this room! \n Good Luck..."]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            sceneView.delegate = self
            
            let portal = SCNText(string: "Portal",extrusionDepth: 0)
                let fire1 = SCNText(string: "Fire 1",extrusionDepth: 0)
                let fire2 = SCNText(string: "Fire 2",extrusionDepth: 0)
                let bingkaiKiri = SCNText(string: "Bingkai Kiri",extrusionDepth: 0)
                let brankas = SCNText(string: "Brankas",extrusionDepth: 0)
                let bingkaiKanan = SCNText(string: "Binkai Kanan",extrusionDepth: 0)
                let youDontWant = SCNText(string: "You Dont Want to Escape",extrusionDepth: 0)
                let grim = SCNText(string: "grim",extrusionDepth: 0)
                
            
               
                
                
                let material = SCNMaterial()

                material.diffuse.contents = UIColor.red

                portal.materials = [material]
                fire1.materials = [material]
                fire2.materials = [material]
                bingkaiKiri.materials = [material]
                bingkaiKanan.materials = [material]
                brankas.materials = [material]
                youDontWant.materials = [material]
                grim.materials = [material]

                let nodePortal = SCNNode()
                nodePortal.position = SCNVector3(x : -0.1, y: 0, z : -5)
                nodePortal.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
                nodePortal.geometry = portal
                sceneView.scene.rootNode.addChildNode(nodePortal)
                sceneView.autoenablesDefaultLighting = true

                let nodeYouDont = SCNNode()
                nodeYouDont.position = SCNVector3(x : -0.1, y: 0.5, z : 5)
                nodeYouDont.scale = SCNVector3(x: -0.01, y: 0.01, z: -0.01)
                nodeYouDont.geometry = youDontWant
                sceneView.scene.rootNode.addChildNode(nodeYouDont)
                sceneView.autoenablesDefaultLighting = true

                let FireKiri = SCNNode()
                FireKiri.position = SCNVector3(x : -1, y: 1.5, z : -5)
                FireKiri.scale = SCNVector3(x: 0.01, y: 0.02, z: 0.01)
                FireKiri.geometry = fire1
                sceneView.scene.rootNode.addChildNode(FireKiri)
                sceneView.autoenablesDefaultLighting = true

                 let FireKanan = SCNNode()
                FireKanan.position = SCNVector3(x : 1, y: 1.5, z : -5)
                FireKanan.scale = SCNVector3(x: 0.01, y: 0.02, z: 0.01)
                FireKanan.geometry = fire2
                sceneView.scene.rootNode.addChildNode(FireKanan)
                sceneView.autoenablesDefaultLighting = true

                let nodeBingkaiKiri = SCNNode()
                nodeBingkaiKiri.position = SCNVector3(x : -5, y: 1.5, z : -0.6)
                nodeBingkaiKiri.rotation = SCNVector4Make(0, 1, 0, .pi / -2)
                nodeBingkaiKiri.scale = SCNVector3(x: -0.01, y: 0.05, z: -0.3)
                nodeBingkaiKiri.geometry = bingkaiKiri
                sceneView.scene.rootNode.addChildNode(nodeBingkaiKiri)
                sceneView.autoenablesDefaultLighting = true
            
                let nodeGrim = SCNNode()
                nodeGrim.position = SCNVector3(x : -5, y: -1.5, z : 0.6)
                nodeGrim.rotation = SCNVector4Make(0, 1, 0, .pi / -2)
                nodeGrim.scale = SCNVector3(x: -0.01, y: 0.05, z: -0.3)
                nodeGrim.geometry = grim
                sceneView.scene.rootNode.addChildNode(nodeGrim)
                sceneView.autoenablesDefaultLighting = true
                
                let nodeBingkaiKanan = SCNNode()
                nodeBingkaiKanan.position = SCNVector3(x : 5, y: 1, z : -1)
                nodeBingkaiKanan.rotation = SCNVector4Make(0, 1, 0, .pi / 2)
                nodeBingkaiKanan.scale = SCNVector3(x: -0.01, y: 0.05, z: -0.3)
                nodeBingkaiKanan.geometry = bingkaiKanan
                sceneView.scene.rootNode.addChildNode(nodeBingkaiKanan)
                sceneView.autoenablesDefaultLighting = true
                
                let nodeBrankas = SCNNode()
                nodeBrankas.position = SCNVector3(x : 5, y: -2, z : 1)
                nodeBrankas.rotation = SCNVector4Make(0, 1, 0, .pi / 2)
                nodeBrankas.scale = SCNVector3(x: -0.01, y: 0.05, z: -0.3)
                nodeBrankas.geometry = brankas
                sceneView.scene.rootNode.addChildNode(nodeBrankas)
                sceneView.autoenablesDefaultLighting = true
            
            let bingkaiGeometry = SCNPlane(width: 2, height: 1)
            let bingkaiMaterial = SCNMaterial()
            bingkaiMaterial.diffuse.contents = UIImage(named: "PROCEED")
            bingkaiGeometry.materials = [bingkaiMaterial]
            
            let nodeBingkai = SCNNode()
            nodeBingkai.position = SCNVector3(x : -0.1, y: -0.5, z : -5)
            nodeBingkai.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
            nodeBingkai.geometry = bingkaiGeometry
            sceneView.scene.rootNode.addChildNode(nodeBingkai)
            sceneView.autoenablesDefaultLighting = true
            
            // Show statistics such as fps and timing information
            sceneView.showsStatistics = true
            
            viewSetup()
        }
        
        func viewSetup() {
            recommendationViewContainer.isHidden = false
            npcViewController.isHidden = true
            
            npcImage.loadGif(name: "FireballARemake")
            contentLabel.text = convArray[0]
            
            prevButtonHidden()
        }
        
        func prevButtonHidden() {
            prevButtonImage.isHidden = true
            prevButton.isHidden = true
        }
        
        func prevButtonHiddenFalse() {
            prevButtonImage.isHidden = false
            prevButton.isHidden = false
        }

        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // Create a session configuration
            let configuration = ARWorldTrackingConfiguration()

            // Run the view's session
            sceneView.session.run(configuration)
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            // Pause the view's session
            sceneView.session.pause()
        }
        @IBAction func proceedButton(_ sender: Any) {
            recommendationViewContainer.isHidden = true
            npcViewController.isHidden = false
        }
        
        @IBAction func nextButtonAction(_ sender: Any) {
            if contentLabel.text == convArray[0] {
                 contentLabel.text = convArray[1]
                 prevButtonHiddenFalse()
             } else if contentLabel.text == convArray[1]{
                 contentLabel.text = convArray[2]
                 prevButtonHiddenFalse()
             }else if contentLabel.text == convArray[2]{
                 contentLabel.text = convArray[3]
                 prevButtonHiddenFalse()
             }else if contentLabel.text == convArray[3]{
                 npcViewController.isHidden = true
             }
        }
        
        @IBAction func prevButtonAction(_ sender: Any) {
            if contentLabel.text == convArray[0]{
                prevButtonHidden()
            }else if contentLabel.text == convArray [1]{
                contentLabel.text = convArray[0]
                prevButtonHidden()
            }else if contentLabel.text == convArray[2]{
                contentLabel.text = convArray[1]
            }else if contentLabel.text == convArray[3]{
                contentLabel.text = convArray[2]
            }
        }
        
      

    }

