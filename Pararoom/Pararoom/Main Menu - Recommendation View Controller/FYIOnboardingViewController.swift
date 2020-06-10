//
//  FYIOnboardingViewController.swift
//  Pararoom
//
//  Created by Rommy Julius Dwidharma on 10/06/20.
//  Copyright © 2020 Maria Jeffina. All rights reserved.
//

import UIKit

class FYIOnboardingViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backgroundImage.loadGif(name: "gameBg")
        self.view.sendSubviewToBack(backgroundImage)
        self.view.bringSubviewToFront(contentView)
    }
    
    
    @IBAction func proceedButton(_ sender: Any) {
        performSegue(withIdentifier: "permissionAndRecommendation", sender: self)
    }

}
