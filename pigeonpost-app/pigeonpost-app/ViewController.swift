//
//  ViewController.swift
//  pigeonpost-app
//
//  Created by Charlotte McHugh on 9/7/18.
//  Copyright © 2018 Charlotte McHugh. All rights reserved.
//

import UIKit
import DJISDK
import Foundation

class ViewController: UIViewController, DJISDKManagerDelegate {
    
    var current_user = ""
    
    // login page
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var errMsg: UILabel!
    
    // sign up page
    @IBOutlet weak var newPswd: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var newUsrErr: UILabel!
    
    // settings page
    @IBOutlet weak var updateEmail: UITextField!
    @IBOutlet weak var updateFirstName: UITextField!
    @IBOutlet weak var updateLastName: UITextField!
    @IBOutlet weak var updatePassword: UITextField!
    
    
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

    // LOGIN PAGE  *********************************
    @IBAction func loginButton(_ sender: Any) {
        guard let url = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/auth?email=" + username.text! + "&password=" + password.text!) else { return }
        
        var statusCode: Int = 0
        var request = URLRequest(url: url)
        let semaphore = DispatchSemaphore(value: 0)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
                statusCode = httpResponse.statusCode
            }
            semaphore.signal()
            
        }.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        if statusCode == 200 {
            print("Login success")
            current_user = username.text!
            self.performSegue(withIdentifier: "loginToHome", sender: sender)
        }
        else {
            print("Login Failed")
            self.errMsg.text = "Invalid login credentials."
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
            
            performSegue(withIdentifier: "signUpToHome", sender: sender)
            
        }
    }
    
    // SETTINGS PAGE  *********************************
    @IBAction func settingsBckButton(_ sender: Any) {
        performSegue(withIdentifier: "settingsToHome", sender: sender)
    }
}



class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        performSegue(withIdentifier: "homeToLogin", sender: sender)
    }
    
    @IBAction func callDroneButton(_ sender: Any) {
        performSegue(withIdentifier: "homeToCallDrone", sender: sender)
    }
    
    @IBAction func sendDroneButton(_ sender: Any) {
        // TODO: Send delivery request to recipient
        let responseCode = 200
        if responseCode == 200 {
            self.showAlertViewWithTitle(title:"Drone Request Sent", withMessage: "Your delivery request has been sent! Check Pending Deliveries for updates.")
        }
        else {
            self.showAlertViewWithTitle(title:"Delivery Error", withMessage: "An unexpected error occurred. Please try again later.")
        }
    }
    
    @IBAction func settingsButton(_ sender: Any) {
        performSegue(withIdentifier: "homeToSettings", sender: sender)
    }
    
    @IBAction func deliveriesButton(_ sender: Any) {
        performSegue(withIdentifier: "homeToDeliveries", sender: sender)
    }
    
    @IBAction func contactsButton(_ sender: Any) {
        performSegue(withIdentifier: "homeToContacts", sender: sender)
    }

    func showAlertViewWithTitle(title: String, withMessage message: String) {
        
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction.init(title:"OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
}


// CONTACTS PAGE
class ContactsViewController: UIViewController {
    
    var contacts = [String]()
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load existing contacts
        // Currently just doing a get request on /users because idk if we have an endpoint for getting contacts?
        guard let url = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/users") else { return }
        
        let names = [String]()
        let semaphore = DispatchSemaphore(value: 0)
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            do {
                let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                print(parsedData)
                if let users = parsedData["users"] as? [String:Any] {
                    users.forEach { user in
                        //names.append(user["email"])
                    }
                }
                
            } catch  {
                print(error)
            }
            //            if let users = users {
            //                print(users)
            //                do {
            //                    let json = try JSONSerialization.jsonObject(with: users, options: [])
            //                    print(json)
            //                } catch {
            //                    print(error)
            //                }
            //            }
            semaphore.signal()
            }.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "contactsToHome", sender: sender)
    }
    
    @IBAction func sendRequestButton(_ sender: Any) {
//        guard let url = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/contacts?user_email_1=" + current_user + "&user_email_2=" + newContactEmail.text!) else { return }
//
//        var statusCode: Int = 0
//        var request = URLRequest(url: url)
//        let semaphore = DispatchSemaphore(value: 0)
//        request.httpMethod = "PUT"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.timeoutInterval = 10
//
//        let session = URLSession.shared
//        session.dataTask(with: request) { (data, response, error) in
//
//            if let httpResponse = response as? HTTPURLResponse {
//                print("Status Code: \(httpResponse.statusCode)")
//                statusCode = httpResponse.statusCode
//            }
//            semaphore.signal()
//
//            }.resume()
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//        if statusCode == 204 {
//            print("Contact added successfully")
//        }
//        else {
//            print("New contact request failed")
//        }
    }
}

// CALL DRONE PAGE
class CallDroneViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var statusLabel: UILabel!
    
    let waypoint1 = MKPointAnnotation()
    let waypoint2 = MKPointAnnotation()
    let waypoint3 = MKPointAnnotation()
    let waypoints = ["Waypoint 1","Waypoint 2","Waypoint 3"]
    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.340646, longitude: -71.097516), span: MKCoordinateSpanMake(0.02, 0.02))
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return waypoints.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return waypoints[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        waypoint1.coordinate = CLLocationCoordinate2D(latitude: 42.339932, longitude: -71.098401)
        waypoint1.title = "Waypoint 1"
        map.addAnnotation(waypoint1)
        
        waypoint2.coordinate = CLLocationCoordinate2D(latitude: 42.341305, longitude: -71.096638)
        waypoint2.title = "Waypoint 2"
        map.addAnnotation(waypoint2)
        
        waypoint3.coordinate = CLLocationCoordinate2D(latitude: 42.340646, longitude: -71.097516)
        waypoint3.title = "Waypoint 3"
        map.addAnnotation(waypoint3)
        
        map.setRegion(region, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "callDroneToHome", sender: sender)
    }
    
    @IBOutlet weak var callCancel: UIButton!
    @IBAction func callDroneButton(_ sender: Any) {
        
        if callCancel.currentTitle == "Request" {
            //TODO: perform delivery request, check response code.
            
            let responseCode = 200
            if responseCode == 200 {
                callCancel.setTitle("Cancel", for: .normal)
                statusLabel.text! = "Confirmed! Drone is on its way to " + waypoints[pickerView.selectedRow(inComponent: 0)]
            } else {
                statusLabel.text! = "An unexpected error occurred."
            }
        } else {
            //TODO: cancel request
            
            let responseCode = 200
            if responseCode == 200 {
                callCancel.setTitle("Request", for: .normal)
                statusLabel.text! = "Drone has been cancelled."
            } else {
                statusLabel.text! = "An unexpected error occurred."
            }
        }
    }
}


// DELIVERIES PAGE
class DeliveriesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "deliveriesToHome", sender: sender)
    }
}
