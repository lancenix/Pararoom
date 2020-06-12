//
//  MainMenuViewController.swift
//  Pararoom
//
//  Created by Rommy Julius Dwidharma on 10/06/20.
//  Copyright © 2020 Maria Jeffina. All rights reserved.
//

import UIKit
import AVFoundation

class MainMenuViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var onboardingViewContainer: UIView!
    
    var player: AVAudioPlayer?
    var tapSoundFX : AVAudioPlayer?
    
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
        
        let urlString = Bundle.main.path(forResource: "BGM", ofType: "mp3")
        do {
           try AVAudioSession.sharedInstance().setMode(.default)
            guard let urlString = urlString else {
                return
            }
            
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
            guard let player = player else{
                return
            }
            player.numberOfLoops = -1
            player.play()
        }catch let error{
             print(error.localizedDescription)
        }
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        menuView.isHidden = true
        onboardingViewContainer.isHidden = false
        tapSound()
        
    }
    
    @IBAction func proceedButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toGameplay", sender: self)
        tapSound()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameplayVC = segue.destination as? GamePlayViewController {
            gameplayVC.bgm = player
            gameplayVC.bgm?.volume = 0.2
        }
    }
    
    func tapSound() {
        let pathToSound = Bundle.main.path(forResource: "tap interaction", ofType: "wav")!
        let url = URL(fileURLWithPath: pathToSound)
        
        do{
            tapSoundFX = try AVAudioPlayer(contentsOf: url)
            tapSoundFX?.play()
        } catch{
            
        }
    }
    
}
