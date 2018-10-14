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

var current_user_email = ""
var current_user_id = 0
var current_user_fname = ""
var current_user_lname = ""

class ViewController: UIViewController {
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
                print(httpResponse)
            }
            semaphore.signal()
            
        }.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        if statusCode == 200 {
            print("Login success")
            current_user_email = username.text!
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
            self.showAlertViewWithTitle(title:"Account Created!", withMessage: "Your account has been created. Please go back to login for the first time.")
            
        }
    }
    
    func showAlertViewWithTitle(title: String, withMessage message: String) {
        
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction.init(title:"OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}



class HomeViewController: UIViewController, DJISDKManagerDelegate {
    
    @IBOutlet weak var batteryLabel: UILabel!
    @IBOutlet weak var bindingStateLabel: UILabel!
    //var aircraftBindingState: DJIAppActivationAircraftBindingState
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DJISDKManager.registerApp(with: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UpdateUI function for DJI state
    // https://developer.dji.com/mobile-sdk/documentation/ios-tutorials/ActivationAndBinding.html
    func updateUI() {
//        switch (self.aircraftBindingState) {
//        case DJIAppActivationAircraftBindingStateUnboundButCannotSync:
//            self.bindingStateLabel.text = @"Unbound. Please connect Internet to update state. ";
//            break;
//        case DJIAppActivationAircraftBindingStateUnbound:
//            self.bindingStateLabel.text = @"Unbound. Use DJI GO to bind the aircraft. ";
//            break;
//        case DJIAppActivationAircraftBindingStateUnknown:
//            self.bindingStateLabel.text = @"Unknown";
//            break;
//        case DJIAppActivationAircraftBindingStateBound:
//            self.bindingStateLabel.text = @"Bound";
//            break;
//        case DJIAppActivationAircraftBindingStateInitial:
//            self.bindingStateLabel.text = @"Initial";
//            break;
//        case DJIAppActivationAircraftBindingStateNotRequired:
//            self.bindingStateLabel.text = @"Binding is not required. ";
//            break;
//        case DJIAppActivationAircraftBindingStateNotSupported:
//            self.bindingStateLabel.text = @"App Activation is not supported. ";

    }
    
    // DJISDKManagerDelegate Methods
    func productConnected(_ product: DJIBaseProduct?) {
        NSLog("Product Connected")
    }
    func productDisconnected() {
        NSLog("Product Disconnected")
    }
    
    func appRegisteredWithError(_ error: Error?) {
        
        var message = "Register App Succeeded!"
        if (error != nil) {
            message = "Register app failed! Please enter your app key and check the network."
        }else{
            NSLog(message);
        }
        
        //self.showAlertViewWithTitle(title:"Register App", withMessage: message)
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        performSegue(withIdentifier: "homeToLogin", sender: sender)
    }
    
    @IBAction func callDroneButton(_ sender: Any) {
        // check if summoning is already in progress
        guard let url = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/deliveries") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        let semaphore = DispatchSemaphore(value: 0)
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print("JSON Response: \(response)")
            }
            
            if let data = data {
                print("Data: \(data)")
                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                
                        let meta = parseJSON!["meta"] as? [String:Any]
                        print("Meta: \(meta)")
                
                    } catch { print(error) }
            }
            semaphore.signal()
            }.resume()
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        //TODO: check if there are any summons in progress, if so execute
        //if call_in_progress {
            // go to in progress page, e.g. performSegue(withIdentifier: "homeToCallDrone2", sender: sender)
        //} else {
            performSegue(withIdentifier: "homeToCallDrone", sender: sender)
        //}
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
    @IBOutlet weak var contactsTable: UITableView!
    @IBOutlet weak var confirmationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let semaphore = DispatchSemaphore(value: 0)
        guard let url = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/users") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (users, response, error) in
            
            if let users = users {
                do {
                    let json = try JSONSerialization.jsonObject(with: users, options: [])
                    print("JSON:")
                    print(json)
                    print(type(of: json))
                } catch {
                    print(error)
                }
            }
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
        
        let dict = ["user_email_1":current_user_email, "user_email_2": email.text!] as [String : Any]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
            return
        }
        
        guard let url = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/contacts") else { return }
        
        var statusCode: Int = 0
        var request = URLRequest(url: url)
        let semaphore = DispatchSemaphore(value: 0)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData as Data
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
        if statusCode == 204 || statusCode == 201 || statusCode == 200 {
            email.text! = ""
            confirmationLabel.text! = "Contact added!"
            print("Contact added successfully")
        }
        else {
            confirmationLabel.text! = "Unable to add contact. Please try again later."
            print("New contact request failed")
        }
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
            //TODO: perform delivery request, check response code
            var lat = 0.0
            var long = 0.0
            if waypoints[pickerView.selectedRow(inComponent: 0)] == "Waypoint 1" {
                lat = 42.339932
                long = -71.098401
            } else if waypoints[pickerView.selectedRow(inComponent: 0)] == "Waypoint 2" {
                lat = 42.341305
                long = -71.096638
            } else if waypoints[pickerView.selectedRow(inComponent: 0)] == "Waypoint 3" {
                lat = 42.340646
                long = -71.097516
            }
            
            let dict = ["destination": ["latitude":lat, "longitude":long], "sender": ["firstName": current_user_fname, "lastName": current_user_lname, "id": current_user_id], "receiver": ["firstName": current_user_fname, "lastName": current_user_lname, "id": current_user_id]] as [String : Any]
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
                return
            }
            
            guard let url = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/deliveries") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData as Data
            request.timeoutInterval = 10
            var responseCode: Int
            let semaphore = DispatchSemaphore(value: 0)

            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                
                if let response = response {
                    print("JSON Response: \(response)")
                }
                
                if let data = data {
                    print("Data: \(data)")
//                    do {
//                        let parseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
//
//                        let meta = parseJSON!["meta"] as? [String:Any]
//
//                    }catch { print(error) }
                }
                semaphore.signal()
                }.resume()
            
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
            
            responseCode = 200 //for testing, should be removed once we get actual response
            
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
