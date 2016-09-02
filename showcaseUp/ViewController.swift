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

import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let loginButton	= FBSDKLoginButton()
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil{
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }
    
    @IBAction func fbBtnPressed(sender: UIButton!)
    {
        let fbLogin = FBSDKLoginManager()
        
        //UPDATE: Use logInWithReadPermissions fromviewController
        fbLogin.logInWithReadPermissions(["email"], fromViewController: self, handler: {
            (fbResult: FBSDKLoginManagerLoginResult!, fbError: NSError!) in
            if fbError != nil{
               print("Login Failed. \(fbError)")
            } else{
                let accessToken = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            print("Successfully logged in to facebook \(accessToken)")
                
            //DataService.instance.REF_BASE --> Deprecated
            //Replaced by the signInWithCredentials method below:
            FIRAuth.auth()?.signInWithCredential(accessToken, completion: {
                (authData: FIRUser?, error: NSError?) in
                
                if error != nil{
                    print("Login Failed. \(error)")
                }else {
                    print("Logged In! \(authData?.providerID)")
                    
                    NSUserDefaults.standardUserDefaults().setValue(authData?.uid, forKey: KEY_UID)
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
                })
            }
        })
    }
    
    @IBAction func loginBtnPressed(sender: UIButton!)
    {
        if let email = emailTextField.text where email != "",
             let pwd = pwdTextField.text where pwd != ""
        {
            FIRAuth.auth()?.createUserWithEmail(email, password: pwd, completion: { (user: FIRUser?, error: NSError?) in
                if error != nil{
                    print(error)
                    
                    if error?.code == STATUS_ACCOUNT_NONEXISTENT{
                        self.showLoginErrorAlert("Account Does Not Exist", msg: "Login with Facebook/Twitter or create new account")
                    }
                }
            })
            
        } else{
            showLoginErrorAlert("Email and Password Required", msg: "Sorry, please enter both email and password to proceed")
        }
        
    }
    
    @IBAction func registerBtnPressed(sender: UIButton){
        self.performSegueWithIdentifier("registerUser", sender: sender)
    }
    
    
    func showLoginErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    

}

