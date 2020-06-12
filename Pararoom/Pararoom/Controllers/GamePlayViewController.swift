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
import CoreMotion
import AVFoundation

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

    @IBOutlet weak var labelFrameKiri: UILabel!
    @IBOutlet weak var enterPINButton: UIButton!
    @IBOutlet weak var woodImage: UIButton!
    @IBOutlet weak var soulFragment: UIButton!
    @IBOutlet weak var hammerButton: UIButton!
    @IBOutlet weak var deadFireballButton: UIButton!
    
    @IBOutlet weak var npcEndingViewController: UIView!
    
    @IBOutlet weak var contentLabelEnding: UILabel!
    @IBOutlet weak var nextButtonEnding: UIButton!
    @IBOutlet weak var prevButtonEnding: UIButton!
    @IBOutlet weak var prevButtonEndingImage: UIImageView!
    @IBOutlet weak var nextButtonEndingImage: UIImageView!
    @IBOutlet weak var npcImageEnding: UIImageView!
    @IBOutlet weak var jumpScareimg: UIImageView!
    
    
    var prologue = ["Well… Well… Well… \n Look Who’s Here!!!", "I can see you’re trapped, I know a way how to escape but there is one condition...", "That is if you help me find a soul fragment to revive my friend... I'll help you escape!!", "You can find the soul fragment by interacting from this room! \n Good Luck..."]
    var inventoryItem : [String] = ["", "", ""]
    let pinChoices = ["Heart", "Soul", "Fire"]
    private let correctPIN = "34373"
    
    //MARK: Flags
    var fragmentIsSelected = false
    var hammerIsSelected = false
    var takeHammerFlag = false
    var takeFragmentFlag = false
    private var woodDestroyedFlag = false
    private var flagPin = false
    private var showPainting = false
    var isSelected = true
    var gerakFrameKiri = true
    private var fireballIsAlive = false
//    var manager = CMMotionManager()
    
    
    let nodeBrankas = SCNNode()
    let nodeWoodboard = SCNNode()
    let nodeGrim = SCNNode()
    let FireKiri = SCNNode()
    let nodePortal = SCNNode()
    
    var animationProperty = UIViewPropertyAnimator()
    
    var soundEffect: AVAudioPlayer?
    var bgm: AVAudioPlayer?
    var tapSoundFX2: AVAudioPlayer?

    var ending = ["Not Bad!! Seem you have the potential to survive!", "But Remember… \nYour journey don’t end here. Good Luck!!"]
    
   
    
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
        
        viewSetup()
        
        
        registerGestureRecognizers()
    }
    
        
    @IBAction func woodPressed(_ sender: Any) {
        if hammerIsSelected{
            nailSound()
            nodeWoodboard.isHidden = true
            woodImage.isHidden = true
            woodDestroyedFlag = true
            soulFragment.isHidden = false
        }
        else {
            nodeInteractionMessage.isHidden = false
            nodeInteractionMessage.text = "You need a tool to open this board"
        }
    }
    
    @IBAction func hideNodeInteractionView(_ sender: Any) {
        if fireballIsAlive {
            endingSetup()
        }
        
        NodeInteractionView.isHidden = true
        tappingSound()
        showPainting = false
        PINChoicesCollectionView.isHidden = true
        nodeInteractionMessage.isHidden = true
        enterPINButton.isHidden = true
        showPainting = false
        jumpScareimg.isHidden = true
//        manager.stopDeviceMotionUpdates()
        
        
    }
    
    @IBAction func skullRevived(_ sender: Any) {
        if fragmentIsSelected {
            solveSound()
            FireKiri.geometry?.materials.first?.diffuse.contents = UIImage.gif(name: "FireballB_SFX")
            fireballIsAlive = true
            deadFireballButton.isHidden = true
            ZoomedNodeImage.isHidden = false
            ZoomedNodeImage.image = UIImage.gif(name: "FireballB_SFX")
            nodeInteractionMessage.text = "I appreciate your effort."
            nodePortal.isHidden = false
        }
    }
    
    @IBAction func takeSoulFragment(_ sender: Any) {
        tappingSound()
        soulFragment.isHidden = true
        takeFragmentFlag = true
        inventoryItem[1] = "soul_fragment"
        inventoryCollectionView.reloadData()
    }
    
    @IBAction func tapHammer(_ sender: Any) {
        tappingSound()
        hammerButton.isHidden = true
        takeHammerFlag = true
        inventoryItem[0] = "hammer"
        inventoryCollectionView.reloadData()

        labelFrameKiri.isHidden = true
        
        
        
        print(showPainting)

    }
    
    @IBAction func enterPINAlert(_ sender: Any) {
        let alertController = UIAlertController(title: "Enter PIN", message: nil, preferredStyle: .alert)
                
        //Setup actions
        let addAction = UIAlertAction(title: "Confirm", style: .default) { _ in
        
            guard let PIN = alertController.textFields?.first?.text else {return}
            if PIN == self.correctPIN {
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
    
    //MARK: Setup node interaction
    @objc func tapped(recognizer :UITapGestureRecognizer) {
        let sceneView = recognizer.view as! ARSCNView
        let touchLocation = recognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(touchLocation, options: [:])
        
        if !hitResults.isEmpty {
            if !showPainting {
                woodImage.isHidden = true
            }
            ZoomedNodeImage.isHidden = false
            deadFireballButton.isHidden = true
            if hitResults.first?.node.name == "nodeBrangkas" {
                tappingSound()
                ZoomedNodeImage.image = (hitResults.first?.node.geometry?.materials.first?.diffuse.contents as! UIImage)
                NodeInteractionView.isHidden = false
                nodeInteractionMessage.isHidden = false
                nodeInteractionMessage.text = "This safety box needs a PIN for it to be opened. What is it?"
                
                
                if takeHammerFlag {
                    enterPINButton.isHidden = true
                    nodeInteractionMessage.text = "There's nothing to see here..."
                }
                else {
                    enterPINButton.isHidden = false
                }
            }
            else if hitResults.first?.node.name == "nodePainting"{
                tappingSound()
                showPainting = true
                ZoomedNodeImage.image = UIImage(named: "painting_wood")
                deadFireballButton.isHidden = true
                if !woodDestroyedFlag {
                    woodImage.isHidden = false
                }
                NodeInteractionView.isHidden = false
            }
            else if hitResults.first?.node.name == "grimRiper"{
                tappingSound()
                ZoomedNodeImage.image = UIImage(named: "grimreaper")
                
                NodeInteractionView.isHidden = false
                PINChoicesCollectionView.isHidden = false
                PINChoicesCollectionView.isHidden = false
                nodeInteractionMessage.isHidden = false
                
                nodeInteractionMessage.text = "What are the thing that you need?"
            }
                
            else if hitResults.first?.node.name == "frameKiri"{
                tappingSound()
                ZoomedNodeImage.image = UIImage(named: "frame answered")
                
//                let interval = 0.01
//
//
//                manager.deviceMotionUpdateInterval = interval
//                let queue = OperationQueue()
//
//                manager.startDeviceMotionUpdates(to: queue, withHandler: {(data, error) in
//                guard let data = data else { return }
//                    guard self.manager.isDeviceMotionAvailable else { return }
//                let gravity = data.gravity
//                    let rotation = atan2(gravity.x, gravity.y) - .pi
//
//                    OperationQueue.main.addOperation {
//                        self.ZoomedNodeImage?.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
//                    }
//                })
                NodeInteractionView.isHidden = false
            }
            else if hitResults.first?.node.name == "fireKanan" {
                tappingSound()
                ZoomedNodeImage.image = UIImage.gif(name: "FireballA_SFX")
                NodeInteractionView.isHidden = false
                
                nodeInteractionMessage.text = "So have you found it?"
                nodeInteractionMessage.isHidden = false
            }
            else if hitResults.first?.node.name == "fireKiri" {
                tappingSound()
                NodeInteractionView.isHidden = false
                if fireballIsAlive {
                    ZoomedNodeImage.image = UIImage.gif(name: "FireballB_SFX")
                    nodeInteractionMessage.text = "I appreciate your effort."
                }
                else {
                    ZoomedNodeImage.isHidden = true
                    deadFireballButton.isHidden = false
                    deadFireballButton.imageEdgeInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
                        nodeInteractionMessage.text = "This fireball needs a soul fragment to be revived"
                        nodeInteractionMessage.isHidden = false
                    
                }
            }
            else if hitResults.first?.node.name == "nodePortal" {
                print("segue to congratulations")
                performSegue(withIdentifier: "congratulations", sender: nil)
            }
        }
    }
    
    func openSafetyBox(){
        jumpscareSound()
        self.jumpScareimg.isHidden = false
        UIView.animate(withDuration: 2, delay: 2, options: UIView.AnimationOptions.transitionFlipFromTop, animations: {
            self.jumpScareimg.alpha = 0
        }, completion: { finished in
            self.jumpScareimg.isHidden = true
        })
        nodeBrankas.geometry?.materials.first?.diffuse.contents = UIImage(named: "safetybox_open")
        ZoomedNodeImage.image = UIImage(named: "safetybox_open")
        hammerButton.isHidden = false
    }
    
    func viewSetup() {
        recommendationViewContainer.isHidden = false
        
        npcImage.loadGif(name: "FireballARemake")
        npcImageEnding.loadGif(name: "FireballARemake")
        
        inventoryCollectionView.isHidden = true
        NodeInteractionView.isHidden = true
        PINChoicesCollectionView.backgroundColor = .clear
        PINChoicesCollectionView.isHidden = true
        nodeInteractionMessage.isHidden = true
        enterPINButton.isHidden = true
        labelFrameKiri.isHidden = true
        deadFireballButton.isHidden = true
        nodePortal.isHidden = true
        jumpScareimg.isHidden = true
        
        hammerButton.isHidden = true
        soulFragment.isHidden = true
        
        
    }
    
    //MARK: NPC game prologue dialog

    func prologueSetup() {
        npcViewController.isHidden = false
        contentLabel.text = prologue[0]
        
        let urlFire = Bundle.main.path(forResource: "FireCrackleSE", ofType: "wav")
              do {
                 try AVAudioSession.sharedInstance().setMode(.default)
                  guard let urlFire = urlFire else {
                      return
                  }
                  
                  soundEffect = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlFire))
                  guard let soundEffect = soundEffect else{
                      return
                  }
                  soundEffect.numberOfLoops = -1
                  soundEffect.volume = 1
                  soundEffect.play()
              }catch let error{
                   print(error.localizedDescription)
              }
        
        prevButtonHidden()
    }
    
    //MARK: NPC game ending dialog
    func endingSetup(){
        npcEndingViewController.isHidden = false
        contentLabelEnding.text = ending[0]

        let urlFire = Bundle.main.path(forResource: "FireCrackleSE", ofType: "wav")
            do {
                try AVAudioSession.sharedInstance().setMode(.default)
                    guard let urlFire = urlFire else {
                        return
                    }
                         
                soundEffect = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlFire))
                guard let soundEffect = soundEffect else{
                    return
                }
                soundEffect.numberOfLoops = -1
                soundEffect.volume = 1
                soundEffect.play()
            }catch let error{
                print(error.localizedDescription)
            }
        
        prevButtonHiddenEnding()
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
        
        nodePortal.name = "nodePortal"
        nodePortal.geometry = planeGeometry
        nodePortal.position = SCNVector3(x : 0.1, y: 0.1, z : -5)
        sceneView.scene.rootNode.addChildNode(nodePortal)
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    func setupYouDontText(){
        let planeGeometry = SCNPlane(width: 500, height: 500)
        let material = SCNMaterial()
        material.diffuse.contents = UIImageView.init(image: #imageLiteral(resourceName: "YOU DONT"))
        planeGeometry.materials = [material]
        
        let nodeYouDont = SCNNode(geometry: planeGeometry)
        nodeYouDont.position = SCNVector3(x : 0.1, y: 0.1, z : 8)
        nodeYouDont.scale = SCNVector3(x: -0.01, y: 0.01, z: -0.01)
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

        let planeGeometry = SCNPlane(width: 0.5, height: 1)
        let material = SCNMaterial()
        material.diffuse.contents = UIImageView.init(image: #imageLiteral(resourceName: "frame question"))
        planeGeometry.materials = [material]

               let bingkaiKiri = SCNNode(geometry: planeGeometry)
        bingkaiKiri.name = "frameKiri"
        bingkaiKiri.position = SCNVector3(x : -3.5, y: 0.1, z : 0.1)
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
        let planeGeometry = SCNPlane(width: 500, height: 700)
        let material = SCNMaterial()
        material.diffuse.contents = UIImageView.init(image: #imageLiteral(resourceName: "grimreaper"))
        planeGeometry.materials = [material]
        
        nodeGrim.geometry = planeGeometry
        nodeGrim.name = "grimRiper"
        nodeGrim.position = SCNVector3(x : -3, y: -1.5, z : -1)
        nodeGrim.rotation = SCNVector4Make(0, 1, 0, .pi / -2)
        nodeGrim.scale = SCNVector3(x: -0.01, y: 0.05, z: -0.3)
        sceneView.scene.rootNode.addChildNode(nodeGrim)
        sceneView.autoenablesDefaultLighting = true
    }
    
    func setupFire1(){
        
        let planeGeometry = SCNPlane(width: 1, height: 1)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "FireballB_Dead.png")
        planeGeometry.materials = [material]

        
        FireKiri.geometry = planeGeometry
        FireKiri.name = "fireKiri"
        FireKiri.position = SCNVector3(x : -1, y: 2, z : -4)
        sceneView.scene.rootNode.addChildNode(FireKiri)
        sceneView.autoenablesDefaultLighting = true
    }
    
    func setupFire2(){
        let planeGeometry = SCNPlane(width: 5, height: 5)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "FireballA")
        planeGeometry.materials = [material]
        
        let FireKanan = SCNNode(geometry: planeGeometry)
        FireKanan.name = "fireKanan"
        FireKanan.position = SCNVector3(x : 1.5, y: 3, z : -4)
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
    
    func prevButtonHiddenEnding() {
        prevButtonEnding.isHidden = true
        prevButtonEndingImage.isHidden = true
    }
    
    func prevButtonHiddenFalse() {
        prevButtonImage.isHidden = false
        prevButton.isHidden = false
    }
    
    func prevButtonHiddenFalseEnding(){
        prevButtonEnding.isHidden = false
        prevButtonEndingImage.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let congratsVC = segue.destination as? CongratulationViewController {
            congratsVC.bgm = bgm
            congratsVC.bgm?.volume = 1
        }
    }
    
    @IBAction func proceedButton(_ sender: Any) {
        npcViewController.isHidden = false
        UIView.transition(from: recommendationViewContainer, to: npcViewController, duration: 2, options: .transitionCrossDissolve, completion: nil)
        recommendationViewContainer.isHidden = true
    
        prologueSetup()
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        //prologue
        if contentLabel.text == prologue[0] {
            tappingSound()
            prevButtonHiddenFalse()
            UIView.transition(with: contentLabel, duration: 1, options: .transitionCrossDissolve, animations: {
                self.contentLabel.text = self.prologue[1]
            }, completion: nil)
         } else if contentLabel.text == prologue[1]{
            tappingSound()
             contentLabel.text = prologue[2]
             prevButtonHiddenFalse()
            UIView.transition(with: contentLabel, duration: 1, options: .transitionCrossDissolve, animations: {
                self.contentLabel.text = self.prologue[2]
            }, completion: nil)
         }else if contentLabel.text == prologue[2]{
            tappingSound()
             contentLabel.text = prologue[3]
             prevButtonHiddenFalse()
            UIView.transition(with: contentLabel, duration: 1, options: .transitionCrossDissolve, animations: {
                self.contentLabel.text = self.prologue[3]
            }, completion: nil)
         }else if contentLabel.text == prologue[3]{
            grimSound()
            UIView.transition(from: npcViewController, to: inventoryCollectionView, duration: 2, options: .transitionCrossDissolve, completion: nil)
            npcViewController.isHidden = true
            inventoryCollectionView.isHidden = false
            soundEffect!.stop()
         }
    }
    
    @IBAction func prevButtonAction(_ sender: Any) {
        //prologue
        if contentLabel.text == prologue[0]{
            prevButtonHidden()
        }else if contentLabel.text == prologue [1]{
            tappingSound()
            contentLabel.text = prologue[0]
            UIView.transition(with: contentLabel, duration: 1, options: .transitionCrossDissolve, animations: {
                self.contentLabel.text = self.prologue[0]
            }, completion: nil)

            prevButtonHidden()
        }else if contentLabel.text == prologue[2]{
            tappingSound()
            contentLabel.text = prologue[1]
            UIView.transition(with: contentLabel, duration: 1, options: .transitionCrossDissolve, animations: {
                self.contentLabel.text = self.prologue[1]
            }, completion: nil)
        }else if contentLabel.text == prologue[3]{
            tappingSound()
            contentLabel.text = prologue[2]
            UIView.transition(with: contentLabel, duration: 1, options: .transitionCrossDissolve, animations: {
                self.contentLabel.text = self.prologue[2]
            }, completion: nil)
        }
    }
    
    @IBAction func nextButtonEnding(_ sender: Any) {
        if contentLabelEnding.text == ending[0]{
            prevButtonHiddenFalseEnding()
            UIView.transition(with: contentLabelEnding, duration: 1, options: .transitionCrossDissolve, animations: { self.contentLabelEnding.text = self.ending[1] }, completion: nil)
        }else if contentLabelEnding.text == ending[1]{
            npcEndingViewController.isHidden = true
            soundEffect!.stop()
        }
    }
    
    @IBAction func prevButtonEnding(_ sender: Any) {
        if contentLabelEnding.text == ending[0]{
                  prevButtonHiddenEnding()
              }else if contentLabelEnding.text == ending[1]{
                  contentLabelEnding.text = ending[0]
                  UIView.transition(with: contentLabelEnding, duration: 1, options: .transitionCrossDissolve, animations: {
                      self.contentLabelEnding.text = self.ending[0]
                  }, completion: nil)
                  prevButtonHiddenEnding()
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
            
            if isSelected {
                tappingSound()
                selectedCell.contentView.backgroundColor = .brown
                if indexPath.row
                == 0 && inventoryItem[0] != "" {
                    hammerIsSelected = true
                }
                else if indexPath.row == 1 && inventoryItem[1] != "" {
                    fragmentIsSelected = true
                }
                isSelected = false
            } else {
                selectedCell.contentView.backgroundColor = .clear
                isSelected = true
                if indexPath.row
                == 0 && inventoryItem[0] != "" {
                    hammerIsSelected = false
                }
                else if indexPath.row
                == 1 && inventoryItem[1] != "" {
                    fragmentIsSelected = false
                }
            }
        }
        else if collectionView == PINChoicesCollectionView{
            tappingSound()
            let selectedCell:UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
            selectedCell.contentView.backgroundColor = .brown
            if indexPath.row == 1 {
                nodeGrim.isHidden = true
                nodeInteractionMessage.text = "I hope you can escape."
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == inventoryCollectionView {
            let selectedCell:UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
            selectedCell.contentView.backgroundColor = .clear
        }
        else if collectionView == PINChoicesCollectionView{
        let selectedCell:UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
        selectedCell.contentView.backgroundColor = .white
        }
    }
    
    func tappingSound() {
        let pathToSound = Bundle.main.path(forResource: "tap interaction", ofType: "wav")!
        let url = URL(fileURLWithPath: pathToSound)
        
        do{
            tapSoundFX2 = try AVAudioPlayer(contentsOf: url)
            tapSoundFX2?.play()
        } catch{
            
        }
    }
    
    func grimSound() {
        let pathToSound = Bundle.main.path(forResource: "penampakan 1", ofType: "wav")!
        let url = URL(fileURLWithPath: pathToSound)
        
        do{
            tapSoundFX2 = try AVAudioPlayer(contentsOf: url)
            tapSoundFX2?.play()
        } catch{
            
        }
    }
    
    func nailSound() {
        let pathToSound = Bundle.main.path(forResource: "nailpulling", ofType: "mp3")!
        let url = URL(fileURLWithPath: pathToSound)
        
        do{
            tapSoundFX2 = try AVAudioPlayer(contentsOf: url)
            tapSoundFX2?.play()
        } catch{
            
        }
    }
    
    func jumpscareSound() {
        let pathToSound = Bundle.main.path(forResource: "Jumpscare safebox", ofType: "wav")!
        let url = URL(fileURLWithPath: pathToSound)
        
        do{
            tapSoundFX2 = try AVAudioPlayer(contentsOf: url)
            tapSoundFX2?.play()
        } catch{
            
        }
    }
    
    func solveSound() {
        let pathToSound = Bundle.main.path(forResource: "Puzzle 1 solved", ofType: "wav")!
        let url = URL(fileURLWithPath: pathToSound)
        
        do{
            tapSoundFX2 = try AVAudioPlayer(contentsOf: url)
            tapSoundFX2?.play()
        } catch{
            
        }

    }
    
    func jumpScare() {
        if jumpScareimg.isHidden == false{
        UIView.transition(with: jumpScareimg, duration: 3.5, options: .transitionCrossDissolve, animations: {
            self.jumpScareimg.isHidden = true
        }, completion: nil)
        
    }
    }

    
}
