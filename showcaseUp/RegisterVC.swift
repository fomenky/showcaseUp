//
//  RegisterVC.swift
//  showcaseUp
//
//  Created by AceGod on 9/1/16.
//  Copyright © 2016 AceGod. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func loginBackBtnPressed(sender: UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func registerBtnPressed(sender: UIButton)
    {
        if let email = emailTextField.text where email != "",
            let pwd = pwdTextField.text where pwd != "" && pwd.characters.count > 7
        {
            FIRAuth.auth()?.createUserWithEmail(email, password: pwd, completion: { (user: FIRUser?, error: NSError?) in
                if error != nil{
                    print(error?.code)
                    
                    if error?.code == STATUS_ACCOUNT_EXIST {
                        self.showLoginErrorAlert("Account Already Exists", msg: "Please Login")
                    } else if error?.code == STATUS_EMAIL_BADLY_FORMATTED {
                        self.showLoginErrorAlert("Email Format Invalid", msg: "The email address is badly formatted")
                    }
                } else {
                    self.login()
                }
            })
            
        } else if emailTextField.text == "" || pwdTextField.text == "" {
            showLoginErrorAlert("Email and Password Required", msg: "Please enter both email and password to register")
        } else if pwdTextField.text?.characters.count <= 7 {
            showLoginErrorAlert("Password Invalid", msg: "Password must be greater than 7 characters")
        }
    }
    
    func login()
    {
        FIRAuth.auth()?.signInWithEmail(emailTextField.text!, password: pwdTextField.text!, completion: { (authData: FIRUser?, error: NSError?) in
            
            if error != nil {
                print("PASSWORD IS INCORRECT \(error)")
                self.showLoginErrorAlert("Incorrect Password", msg: "Please check if you have entered the correct password")
            } else{
                print("LOGGED IN \(authData?.providerID)")
                let user: [String: String] = ["provider": "email", "blahuser": "testUser"]
                
                DataService.instance.createFirebaseUser(authData!.uid, user: user)
                
                //Save UserID (uid)
                NSUserDefaults.standardUserDefaults().setValue(authData?.uid, forKey: KEY_UID)
                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
            }
        })
    }
    
    func showLoginErrorAlert(title: String, msg: String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
}
