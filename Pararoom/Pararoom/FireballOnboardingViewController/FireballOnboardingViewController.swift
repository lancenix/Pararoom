//
//  FireballOnboarding_1_ViewController.swift
//  Pararoom
//
//  Created by Rommy Julius Dwidharma on 10/06/20.
//  Copyright © 2020 Maria Jeffina. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class FireballOnboardingViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var npcImage: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButtonImage: UIImageView!
    @IBOutlet weak var nextButtonImage: UIImageView!
    
    var convArray = ["Well… Well… Well… \n Look Who’s Here!!!", "I can see you’re trapped, I know a way how to escape but there is one condition...", "That is if you help me find a soul fragment to revive my friend... I'll help you escape!!", "You can find the soul fragment by interacting from this room! \n Good Luck..."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        npcImage.loadGif(name: "FireballARemake.gif")
//        self.view.sendSubviewToBack(npcImage)
        
        contentLabel.text = convArray[0]
        prevButtonHidden()
        // Do any additional setup after loading the view.
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
    
    func prevButtonHidden() {
        prevButtonImage.isHidden = true
        prevButton.isHidden = true
    }
    
    func prevButtonHiddenFalse() {
        prevButtonImage.isHidden = false
        prevButton.isHidden = false
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
            performSegue(withIdentifier: "toGameplay", sender: self)
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
