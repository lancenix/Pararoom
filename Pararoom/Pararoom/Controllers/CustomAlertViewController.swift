//
//  CustomAlertViewController.swift
//  Pararoom
//
//  Created by Maria Jeffina on 11/06/20.
//  Copyright © 2020 Maria Jeffina. All rights reserved.
//

import UIKit

//MARK: Protocol
//protocol FlagEntryDelegate: AnyObject {
//    func passPIN(_ PIN: String)
//}

class CustomAlertViewController: UIViewController {

    @IBOutlet weak var pinInput: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    private var pinFlag = 0
    private let correctPin = "34373"
    var inputtedPIN = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        pinInput.keyboardType = .numberPad
        pinInput.addTarget(self, action: #selector(self.handleTextChanged), for: .editingChanged)
        
        
    }
    @IBAction func confirmInput(_ sender: Any) {
        guard let PIN = pinInput.text else { return }
        if PIN == correctPin {
            pinFlag = 1
            inputtedPIN = PIN
        }
        self.dismiss(animated: true, completion: nil)
    }
    
     @objc private func handleTextChanged(_ sender: UITextField) {
           
           guard let alertController = presentedViewController as? UIAlertController,
               let addAction = alertController.actions.first,
               let text = sender.text
               
               else { return }
           
           addAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
           
       }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
