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
    @IBOutlet weak var enterPINButton: UIButton!
    
    
    @IBOutlet weak var soulFragment: UIButton!
    
    var convArray = ["Well… Well… Well… \n Look Who’s Here!!!", "I can see you’re trapped, I know a way how to escape but there is one condition...", "That is if you help me find a soul fragment to revive my friend... I'll help you escape!!", "You can find the soul fragment by interacting from this room! \n Good Luck..."]
    
    var takeHammerFlag = 0
    var hammerIsSelected = false
    private var flagPin = false
    private var showPainting = false
    
    private let corretPIN = "34373"
    
    var inventoryItem : [String] = ["", "", ""]
    let pinChoices = ["33321", "34373", "28832"]
    
    let nodeBrankas = SCNNode()
    let nodeWoodboard = SCNNode()
    
    
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
        
        PINChoicesCollectionView.isHidden = true
        nodeInteractionMessage.isHidden = true
        enterPINButton.isHidden = true
        showPainting = false
        print(showPainting)
    }
    
    @IBAction func enterPINAlert(_ sender: Any) {
        let alertController = UIAlertController(title: "Enter PIN", message: nil, preferredStyle: .alert)
                
        //Setup actions
        let addAction = UIAlertAction(title: "Confirm", style: .default) { _ in
        
            guard let PIN = alertController.textFields?.first?.text else {return}
            if PIN == self.corretPIN {
                self.openSafetyBox()
            }
        }
                    
        addAction.isEnabled = false
                
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter the safe's PIN"
            textField.keyboardType = .numberPad
            textField.addTarget(self, action: #selector(self.handleTextChanged), for: .editingChanged)
        })
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
            
        present(alertController, animated: true)
    }
    
    @objc private func handleTextChanged(_ sender: UITextField) {
        
        guard let alertController = presentedViewController as? UIAlertController,
            let addAction = alertController.actions.first,
            let text = sender.text
            
            else { return }
        
        addAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
        
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
            let woodImage = UIImageView(frame: CGRect(x: 35, y: 142, width: 339, height: 170))
            woodImage.tag = 100
            
            if !showPainting {
                if let viewWithTag = self.view.viewWithTag(100) {
                    viewWithTag.removeFromSuperview()
                }
            }
            if hitResults.first?.node.name == "nodeBrangkas" {
                
                ZoomedNodeImage.image = (hitResults.first?.node.geometry?.materials.first?.diffuse.contents as! UIImage)
                NodeInteractionView.isHidden = false
                PINChoicesCollectionView.isHidden = false
                nodeInteractionMessage.isHidden = false
                
                if takeHammerFlag == 1 {
                    enterPINButton.isHidden = true
                }
                else {
                    enterPINButton.isHidden = false
                }
            }
            else if hitResults.first?.node.name == "nodePainting"{
                showPainting = true
                ZoomedNodeImage.image = UIImage(named: "painting_wood")
                
                woodImage.image = UIImage(named: "woodblock")
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                woodImage.isUserInteractionEnabled = true
                woodImage.addGestureRecognizer(tapGestureRecognizer)
                
                ZoomedNodeImage.addSubview(woodImage)
                NodeInteractionView.isHidden = false
            }
            else{
                ZoomedNodeImage.image = (hitResults.first?.node.geometry?.materials.first?.diffuse.contents as! UIImage)
                NodeInteractionView.isHidden = false
            }
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        if hammerIsSelected{
            nodeWoodboard.isHidden
             = true
            print("true")
        }
        
    }
    
    func openSafetyBox(){
        nodeBrankas.geometry?.materials.first?.diffuse.contents = UIImage(named: "safetybox_open")
        ZoomedNodeImage.image = UIImage(named: "safetybox_open")
        soulFragment.isHidden = false
    }
    
    func viewSetup() {
        recommendationViewContainer.isHidden = false
        npcViewController.isHidden = true
        
        npcImage.loadGif(name: "FireballARemake")
        contentLabel.text = convArray[0]
        
        inventoryCollectionView.isHidden = true
        NodeInteractionView.isHidden = true
        PINChoicesCollectionView.backgroundColor = .clear
        PINChoicesCollectionView.isHidden = true
        nodeInteractionMessage.isHidden = true
        enterPINButton.isHidden = true
        
        soulFragment.isHidden = true
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
        nodePortal.name = "nodePortal"
        
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
    
    func setupSoulFragment(){
        let planeGeometry = SCNPlane(width: 5, height: 5)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "soul_fragment")
        planeGeometry.materials = [material]
        
        
    }
    
    func setupBingkaiKiri(){
        let bingkaiKiri = SCNText(string: "Bingkai Kiri",extrusionDepth: 0)
        bingkaiKiri.materials = [SCNMaterial()]
        
        let nodeBingkaiKiri = SCNNode()
        nodeBingkaiKiri.name = "nodeBingkaiKiri"
        
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
        nodeBingkaiKanan.name = "nodePainting"
        
        nodeBingkaiKanan.position = SCNVector3(x : 10, y: 0, z : -1)
        nodeBingkaiKanan.rotation = SCNVector4Make(0, -1, 0, .pi/2)
        
        sceneView.scene.rootNode.addChildNode(nodeBingkaiKanan)
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    func setupWoodboard() {
        let planeGeometry = SCNPlane(width: 4, height: 2)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "woodblock")
        planeGeometry.materials = [material]
        
        
        nodeWoodboard.name = "nodePainting"
        
        nodeWoodboard.geometry = planeGeometry
        nodeWoodboard.position = SCNVector3(8.5, -0.2, -0.8)
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
        
        nodeBrankas.name = "nodeBrangkas"
        
        nodeBrankas.geometry = planeGeometry
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
            
            if inventoryItem[indexPath.row] != "" {
                cellA.item.image = UIImage(named: inventoryItem[indexPath.row])
            }
            return cellA
        }
        else {
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "pinChoicesCell", for: indexPath) as! PINChoicesCollectionViewCell
            cellB.PINLabel.text = pinChoices[indexPath.row]
            cellB.layer.cornerRadius = 10.0
            return cellB
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == inventoryCollectionView {
            let selectedCell:UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
            selectedCell.contentView.backgroundColor = .brown
            if indexPath.row
                == 0 && inventoryItem[0] != "" {
                hammerIsSelected = true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == inventoryCollectionView {
            let selectedCell:UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
            selectedCell.contentView.backgroundColor = .clear
        }
    }
    
    @IBAction func tapHammer(_ sender: Any) {
        soulFragment.isHidden = true
        takeHammerFlag = 1
        inventoryItem[0] = "hammer"
        inventoryCollectionView.reloadData()
    }
}
