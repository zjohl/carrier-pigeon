//
//  ViewController.swift
//  pigeonpost-app
//
//  Created by Charlotte McHugh on 9/7/18.
//  Copyright © 2018 Charlotte McHugh. All rights reserved.
//

import UIKit
import DJISDK

class ViewController: UIViewController, DJISDKManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The following code up to TEXT FIELDS section is referenced from DJI's ImportSDKDemo project:
    // https://github.com/DJI-Mobile-SDK-Tutorials/iOS-ImportAndActivateSDKInXcode-Swift
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DJISDKManager.registerApp(with: self)
        //let connect_result = DJISDKManager.startConnectionToProduct()
        //print("Connection:")
        //print(connect_result)
        //let product_result = DJISDKManager.product()
        //print("Product:")
        //print(product_result ?? "none")
    }
    
    func showAlertViewWithTitle(title: String, withMessage message: String) {
        
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction.init(title:"OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func appRegisteredWithError(_ error: Error?) {
        var message = "Register App Successed!"
        if (error != nil) {
            message = "Register app failed! Please enter your app key and check the network."
        } else{
            print(message);
        }
        
        // testing
        //self.showAlertViewWithTitle(title:"Register App", withMessage: message)
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
        
        
        let dict = ["email":email.text!, "first_name": fname.text!, "last_name": lname.text!,"password":newPswd.text! ] as [String : Any]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
            return
        }
        
        guard let url = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/users") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData as Data
        request.timeoutInterval = 10
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print("JSON Response: \(response)")
            }
            
            
            if let data = data {
                do {
                    let parseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    
                    let meta = parseJSON!["meta"] as? [String:Any]
                    
                }catch { print(error) }
            }
            }.resume()
    }
        /*
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
            }*/
    
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
    var contacts = [String]()
    
    @IBAction func contactsRefresh(_ sender: Any) {
        let arr = getUsers()
        print(arr)
    }
    
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
    
    // REQUESTS FUNCTION   ********************************
    func getUsers() -> Array<String> {
        // Set up the URL request
        let endpoint: String = "https://shielded-mesa-50019.herokuapp.com/api/users"
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return []
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON
            do {
                guard let result = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                print(result.description)
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
        return []
    }
    
    
}

