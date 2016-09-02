//
//  RegisterVC.swift
//  showcaseUp
//
//  Created by AceGod on 9/1/16.
//  Copyright © 2016 AceGod. All rights reserved.
//

import UIKit


class RegisterVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func loginBackBtnPressed(sender: UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func registerBtnPressed(sender: UIButton){
        print("You clicked me")
    }
    
}
