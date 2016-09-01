//
//  ViewController.swift
//  showcaseUp
//
//  Created by AceGod on 8/31/16.
//  Copyright © 2016 AceGod. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let loginButton	= FBSDKLoginButton()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func fbBtnPressed(sender: UIButton!)
    {
        let fbLogin = FBSDKLoginManager()
        fbLogin.logInWithReadPermissions(["email"]) { (fbLoginResult: FBSDKLoginManagerLoginResult!, fbErr: NSError!) in
            if let err = fbErr{
                print(err.localizedDescription)
            }else{
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Successfully logged in to facebook. \(accessToken)")
            }
        }
    }
    


}

