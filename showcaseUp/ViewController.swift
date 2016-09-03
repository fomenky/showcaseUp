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
            FIRAuth.auth()?.signInWithEmail(email, password: pwd, completion: {
                (authData: FIRUser?, error: NSError?) in
                if error != nil{
                    print(error?.code)
                    
                    if error?.code == STATUS_ACCOUNT_NONEXISTENT{
                        self.showLoginErrorAlert("Account Does Not Exist", msg: "Register or Login with Facebook/Twitter")
                    } else if error?.code == STATUS_EMAIL_INVALID{
                        self.showLoginErrorAlert("Email Format Invalid", msg: "The email address is badly formatted")
                    } else if error?.code == STATUS_INVALID_PASSWORD{
                        self.showLoginErrorAlert("Invalid Password", msg: "The password you entered is incorrect")
                    }
                }else{
                    print("LOGGED IN \(authData?.providerID)")
                    let user: [String: String] = ["provider": "email", "blahuser": "testUser"]
                    
                    DataService.instance.createFirebaseUser(authData!.uid, user: user)
                    
                    //Save UserID (uid)
                    NSUserDefaults.standardUserDefaults().setValue(authData?.uid, forKey: KEY_UID)
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
            })
            
        } else{
            showLoginErrorAlert("Email and Password Required", msg: "Please enter both email and password to proceed")
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

