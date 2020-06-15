//
//  CongratulationViewController.swift
//  Pararoom
//
//  Created by Rommy Julius Dwidharma on 12/06/20.
//  Copyright © 2020 Maria Jeffina. All rights reserved.
//

import UIKit
import AVFoundation

class CongratulationViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var toMainMenu: UIButton!
    
    var bgm: AVAudioPlayer?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mainmenu = segue.destination as? MainMenuViewController {
            mainmenu.player = bgm
            mainmenu.player?.volume = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backgroundImage.loadGif(name: "gameBackground")
    }
    
    @IBAction func backToMainMenuAction(_ sender: Any) {
        performSegue(withIdentifier: "goToMainMenu", sender: self)
        print("go to main menu")
    }
    
    
}
