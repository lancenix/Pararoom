//
//  MainMenuViewController.swift
//  Pararoom
//
//  Created by Rommy Julius Dwidharma on 10/06/20.
//  Copyright © 2020 Maria Jeffina. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var onboardingViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        overrideUserInterfaceStyle = .dark
        // Do any additional setup after loading the view.
        self.view.sendSubviewToBack(backgroundImage)
        self.view.bringSubviewToFront(menuView)
        
        setupView()
    }
    
    func setupView() {
        backgroundImage.loadGif(name: "gameBg")
        self.view.sendSubviewToBack(backgroundImage)
        self.view.bringSubviewToFront(menuView)
        
        onboardingViewContainer.isHidden = true
    }
    
    @IBAction func playButton(_ sender: Any) {
        menuView.isHidden = true
        onboardingViewContainer.isHidden = false
    }
    
    @IBAction func proceedButton(_ sender: Any) {
        performSegue(withIdentifier: "toGameplay", sender: self)
    }
    
}
