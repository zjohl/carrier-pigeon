//
//  ViewController.swift
//  pigeonpost-app
//
//  Created by Charlotte McHugh on 9/7/18.
//  Copyright © 2018 Charlotte McHugh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TEXT FIELDS *********************************
    // login page
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    
    // sign up page
    @IBOutlet weak var newPswd: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var email: UITextField!
    
    // LABELS *********************************
    // login
    @IBOutlet weak var errMsg: UILabel!
    
    // sign up
    @IBOutlet weak var newUsrErr: UILabel!

    // LOGIN PAGE  *********************************
    @IBAction func loginButton(_ sender: Any) {
        // TODO : check usr/pswd against db, hash password
        if username.text!.count > 0 && password.text!.count > 0 {
            print("Success")
            performSegue(withIdentifier: "loginToHome", sender: sender)
        }
        else {
            errMsg.text = "Invalid login credentials."
            print("Invalid login credentials.")
        }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        performSegue(withIdentifier: "loginToSignUp", sender: sender)
    }
    
    // SIGN UP PAGE  *********************************
    @IBAction func cancelButton(_ sender: Any) {
        performSegue(withIdentifier: "signUpToLogin", sender: sender)
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
            if !(email.text!.contains("@")) || !(email.text!.contains(".")) || !(email.text!.count >= 5) {
                print("Invalid email.")
                newUsrErr.text = "Invalid email."
            } else if (fname.text!.count < 1) || (fname.text!.count < 1) {
                print("First and last name are required.")
                newUsrErr.text = "First and last name are required."
            } else if newPswd.text!.count < 3 {
                print("Password must be greater than 3 characters.")
                newUsrErr.text = "Password must be greater than 3 characters."
            } else {
                performSegue(withIdentifier: "signUpToHome", sender: sender)
            }
    }
    
       // HOME PAGE  *********************************
    @IBAction func signOutButton(_ sender: Any) {
        performSegue(withIdentifier: "homeToLogin", sender: sender)
    }
    
    @IBAction func contactsButton(_ sender: Any) {
        performSegue(withIdentifier: "homeToContacts", sender: sender)
    }
    
    @IBAction func delvieriesButton(_ sender: Any) {
        performSegue(withIdentifier: "homeToDeliveries", sender: sender)
    }
    
    @IBAction func settingsButton(_ sender: Any) {
        performSegue(withIdentifier: "homeToSettings", sender: sender)
    }
    
    // CONTACTS PAGE  *********************************
    @IBAction func contactsBackButton(_ sender: Any) {
        performSegue(withIdentifier: "contactsToHome", sender: sender)
    }
    
    // DELIVERIES PAGE  *********************************
    @IBAction func deliveriesBackButton(_ sender: Any) {
        performSegue(withIdentifier: "deliveriesToHome", sender: sender)
    }
    
    // SETTINGS PAGE  *********************************
    @IBAction func settingsBckButton(_ sender: Any) {
        performSegue(withIdentifier: "settingsToHome", sender: sender)
    }
    
}

