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
    @IBOutlet weak var inventoryCollectionView: UICollectionView!
    @IBOutlet weak var PINChoicesCollectionView: UICollectionView!
    @IBOutlet weak var ZoomedNodeImage: UIImageView!
    @IBOutlet weak var nodeInteractionMessage: UILabel!
    @IBOutlet weak var NodeInteractionView: UIView!
    
    
    var convArray = ["Well… Well… Well… \n Look Who’s Here!!!", "I can see you’re trapped, I know a way how to escape but there is one condition...", "That is if you help me find a soul fragment to revive my friend... I'll help you escape!!", "You can find the soul fragment by interacting from this room! \n Good Luck..."]
    var pinChoices = ["33321", "34373", "28832"]
    
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
        
        registerGestureRecognizers()
    }
    
    
    @IBAction func hideNodeInteractionView(_ sender: Any) {
        NodeInteractionView.isHidden = true
    }
    
    
    private func registerGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapped(recognizer :UITapGestureRecognizer) {
        let sceneView = recognizer.view as! ARSCNView
        let touchLocation = recognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(touchLocation, options: [:])
        
        if !hitResults.isEmpty {
            if hitResults.first?.node.name == "nodeBrangkas" {
                ZoomedNodeImage.image = (hitResults.first?.node.geometry?.materials.first?.diffuse.contents as! UIImage)
                NodeInteractionView.isHidden = false
            }
        }
    }
    
    func viewSetup() {
        recommendationViewContainer.isHidden = false
        npcViewController.isHidden = true
        
        npcImage.loadGif(name: "FireballARemake")
        contentLabel.text = convArray[0]
        
        inventoryCollectionView.isHidden = true
        NodeInteractionView.isHidden = true
        PINChoicesCollectionView.backgroundColor = .clear
        
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

          let planeGeometry = SCNPlane(width: 5, height: 10)
                let material = SCNMaterial()
                material.diffuse.contents = UIImageView.init(image: #imageLiteral(resourceName: "portal"))
                planeGeometry.materials = [material]
        //        let youDontWant = SCNText(string: "You Dont Want to Escape",extrusionDepth: 0)
        //        youDontWant.materials = [SCNMaterial()]
                
                let nodePortal = SCNNode(geometry: planeGeometry)
                nodePortal.position = SCNVector3(x : 0.1, y: 0.1, z : -5)
//                nodeYouDont.scale = SCNVector3(x: -0.01, y: 0.01, z: -0.01)
                sceneView.scene.rootNode.addChildNode(nodePortal)
                
                sceneView.autoenablesDefaultLighting = true
    }
    
    func setupYouDontText(){
        let planeGeometry = SCNPlane(width: 500, height: 500)
        let material = SCNMaterial()
        material.diffuse.contents = UIImageView.init(image: #imageLiteral(resourceName: "YOU DONT"))
        planeGeometry.materials = [material]
//        let youDontWant = SCNText(string: "You Dont Want to Escape",extrusionDepth: 0)
//        youDontWant.materials = [SCNMaterial()]
        
        let nodeYouDont = SCNNode(geometry: planeGeometry)
        nodeYouDont.position = SCNVector3(x : 0.1, y: 0.1, z : 5)
        nodeYouDont.scale = SCNVector3(x: -0.01, y: 0.01, z: -0.01)
        sceneView.scene.rootNode.addChildNode(nodeYouDont)
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    func setupBingkaiKiri(){

        let planeGeometry = SCNPlane(width: 0.5, height: 1)
        let material = SCNMaterial()
        material.diffuse.contents = UIImageView.init(image: #imageLiteral(resourceName: "frame question"))
        planeGeometry.materials = [material]
//        let planeGeometry = SCNPlane(width: 15, height: 15)
//               let material = SCNMaterial()
//               material.diffuse.contents = UIImage(named: "frame question")
//               planeGeometry.materials = [material]

               let bingkaiKiri = SCNNode(geometry: planeGeometry)
               bingkaiKiri.position = SCNVector3(x : -1, y: 0.1, z : 0.1)
               bingkaiKiri.rotation = SCNVector4Make(0, -1, 0, .pi / -2)
               sceneView.scene.rootNode.addChildNode(bingkaiKiri)
               sceneView.autoenablesDefaultLighting = true
    }
    
    func setupBingkaiKanan(){
        let planeGeometry = SCNPlane(width: 5, height: 5)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "painting_wood")
        planeGeometry.materials = [material]
        
        let nodeBingkaiKanan = SCNNode(geometry: planeGeometry)
        nodeBingkaiKanan.name = "nodeBingkaiKanan"
        
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
        nodeWoodboard.name = "nodeWoodboard"
        
        nodeWoodboard.position = SCNVector3(6, -0.2, -0.8)
        nodeWoodboard.rotation = SCNVector4Make(0, -1, 0, .pi/2)
        sceneView.scene.rootNode.addChildNode(nodeWoodboard)
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    func setupGrim(){
        let planeGeometry = SCNPlane(width: 500, height: 700)
        let material = SCNMaterial()
        material.diffuse.contents = UIImageView.init(image: #imageLiteral(resourceName: "grimreaper"))
        planeGeometry.materials = [material]
//        let grim = SCNText(string: "grim",extrusionDepth: 0)
//        grim.materials = [SCNMaterial()]
//
//        let nodeGrim = SCNNode()
        let nodeGrim = SCNNode(geometry: planeGeometry)
        nodeGrim.position = SCNVector3(x : -10, y: -1.5, z : 3)
        nodeGrim.rotation = SCNVector4Make(0, 1, 0, .pi / -2)
        nodeGrim.scale = SCNVector3(x: -0.01, y: 0.05, z: -0.3)
//        nodeGrim.geometry = grim
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
        FireKanan.position = SCNVector3(x : 1.5, y: 3, z : -5)
        sceneView.scene.rootNode.addChildNode(FireKanan)
        sceneView.autoenablesDefaultLighting = true
    }
    
    func setupBrankas(){
        
        let planeGeometry = SCNPlane(width: 2, height: 2)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "safetybox_main")
        planeGeometry.materials = [material]
        
        let nodeBrankas = SCNNode(geometry: planeGeometry)
        nodeBrankas.name = "nodeBrangkas"
        
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
            inventoryCollectionView.isHidden = false
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

//MARK: CollectionView Extensions
extension GamePlayViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == inventoryCollectionView {
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "inventoryCell", for: indexPath) as! InventoryCollectionViewCell
            
            return cellA
        }
        else {
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "pinChoicesCell", for: indexPath) as! PINChoicesCollectionViewCell
            cellB.PINLabel.text = pinChoices[indexPath.row]
            cellB.layer.cornerRadius = 10.0
            return cellB
        }
    }
}
