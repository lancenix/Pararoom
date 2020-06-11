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
        
        setupPortal()
        setupYouDontText()
        setupBingkaiKiri()
        setupFire1()
        setupFire2()
        setupBrankas()
        setupBingkaiKanan()
        setupWoodboard()
        setupGrim()
        
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
    
    
    //MARK: Node setups
    func setupPortal(){
        let portal = SCNText(string: "Portal",extrusionDepth: 0)
        portal.materials = [SCNMaterial()]
        
        let nodePortal = SCNNode()
        nodePortal.position = SCNVector3(x : -0.1, y: 0, z : -5)
        nodePortal.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
        nodePortal.geometry = portal
        sceneView.scene.rootNode.addChildNode(nodePortal)
        sceneView.autoenablesDefaultLighting = true
    }
    
    func setupYouDontText(){
        let youDontWant = SCNText(string: "You Dont Want to Escape",extrusionDepth: 0)
        youDontWant.materials = [SCNMaterial()]
        
        let nodeYouDont = SCNNode()
        nodeYouDont.position = SCNVector3(x : -0.1, y: 0.5, z : 5)
        nodeYouDont.scale = SCNVector3(x: -0.01, y: 0.01, z: -0.01)
        nodeYouDont.geometry = youDontWant
        sceneView.scene.rootNode.addChildNode(nodeYouDont)
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    func setupBingkaiKiri(){
        let bingkaiKiri = SCNText(string: "Bingkai Kiri",extrusionDepth: 0)
        bingkaiKiri.materials = [SCNMaterial()]
        
        let nodeBingkaiKiri = SCNNode()
        nodeBingkaiKiri.position = SCNVector3(x : -5, y: 1.5, z : -0.6)
        nodeBingkaiKiri.rotation = SCNVector4Make(0, 1, 0, .pi / -2)
        nodeBingkaiKiri.scale = SCNVector3(x: -0.01, y: 0.05, z: -0.3)
        nodeBingkaiKiri.geometry = bingkaiKiri
        sceneView.scene.rootNode.addChildNode(nodeBingkaiKiri)
        sceneView.autoenablesDefaultLighting = true
    }
    
    func setupBingkaiKanan(){
        let planeGeometry = SCNPlane(width: 5, height: 5)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "painting_wood")
        planeGeometry.materials = [material]
        
        let nodeBingkaiKanan = SCNNode(geometry: planeGeometry)
        nodeBingkaiKanan.position = SCNVector3(x : 7, y: 0, z : -1)
        nodeBingkaiKanan.rotation = SCNVector4Make(0, -1, 0, .pi/2)
        sceneView.scene.rootNode.addChildNode(nodeBingkaiKanan)
        sceneView.autoenablesDefaultLighting = true
    }
    
    func setupWoodboard() {
        let planeGeometry = SCNPlane(width: 4, height: 2)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "woodblock")
        planeGeometry.materials = [material]
        
        let nodeWoodboard = SCNNode(geometry: planeGeometry)
        nodeWoodboard.position = SCNVector3(6, -0.2, -0.8)
        nodeWoodboard.rotation = SCNVector4Make(0, -1, 0, .pi/2)
        sceneView.scene.rootNode.addChildNode(nodeWoodboard)
        sceneView.autoenablesDefaultLighting = true
    }
    
    func setupGrim(){
        let grim = SCNText(string: "grim",extrusionDepth: 0)
        grim.materials = [SCNMaterial()]
        
        let nodeGrim = SCNNode()
        nodeGrim.position = SCNVector3(x : -5, y: -1.5, z : 0.6)
        nodeGrim.rotation = SCNVector4Make(0, 1, 0, .pi / -2)
        nodeGrim.scale = SCNVector3(x: -0.01, y: 0.05, z: -0.3)
        nodeGrim.geometry = grim
        sceneView.scene.rootNode.addChildNode(nodeGrim)
        sceneView.autoenablesDefaultLighting = true
    }
    
    func setupFire1(){
        
        let planeGeometry = SCNPlane(width: 15, height: 15)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "FireballB_Dead.png")
        planeGeometry.materials = [material]

        let FireKiri = SCNNode(geometry: planeGeometry)
        FireKiri.position = SCNVector3(x : -1, y: 1.5, z : -5)
        sceneView.scene.rootNode.addChildNode(FireKiri)
        sceneView.autoenablesDefaultLighting = true
    }
    
    func setupFire2(){
        let planeGeometry = SCNPlane(width: 5, height: 5)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage.gif(name: "FireballARemake")
        planeGeometry.materials = [material]
        
        let FireKanan = SCNNode(geometry: planeGeometry)
        FireKanan.position = SCNVector3(x : 1, y: 2.5, z : -5)
        sceneView.scene.rootNode.addChildNode(FireKanan)
        sceneView.autoenablesDefaultLighting = true
    }
    
    func setupBrankas(){
        
        let planeGeometry = SCNPlane(width: 2, height: 2)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "safetybox_main")
        planeGeometry.materials = [material]
        
        let nodeBrankas = SCNNode(geometry: planeGeometry)
        nodeBrankas.position = SCNVector3(x: 5, y: -0.7, z : 2)
        nodeBrankas.rotation = SCNVector4Make(0, -1, 0, .pi / 2)
        sceneView.scene.rootNode.addChildNode(nodeBrankas)
        sceneView.autoenablesDefaultLighting = true
    }
    
    
    //MARK: Chatbox setups
    func prevButtonHidden() {
        prevButtonImage.isHidden = true
        prevButton.isHidden = true
    }
    
    func prevButtonHiddenFalse() {
        prevButtonImage.isHidden = false
        prevButton.isHidden = false
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

