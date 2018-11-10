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

var currentUser = user(firstName: "", lastName: "", email: "", id: 0, password: "")
var currentDeliveryId = 0

//STRUCTS: based off yaml
struct drone: Decodable {
    var id: Int
    var position: coordinates
    var batterPercent: Int
    var inFlight: String
}

struct coordinates: Decodable {
    var latitude: Float?
    var longitude: Float?
}

struct user: Decodable {
    var firstName: String
    var lastName: String
    var email: String
    var id: Int
    var password: String
}

struct user_with_contacts: Decodable {
    var id: Int
    var firstName: String
    var lastName: String
    var email: String
    var createdDate: String
    var contacts: [contact]
}

struct users_response: Decodable {
    var users: [user]
}

struct userWithContacts: Decodable {
    var firstName: String
    var lastName: String
    var id: Int
    var email: String
    var password: String
    var contacts: [contact]
}

struct contact: Decodable {
    var firstName: String
    var lastName: String
    var id: Int
}

struct delivery: Decodable {
    var id: Int
    var droneId: Int
    var origin: coordinates
    var destination: coordinates
    var status: String
    var sender: contact
    var receiver: contact
    var createdDate: String
    var updatedDate: String
}

struct deliveries_response: Decodable {
    var deliveries: [delivery]
}

//VIEW CONTROLLERS


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
        
        var success: Bool = false
        var request = URLRequest(url: url)
        let semaphore = DispatchSemaphore(value: 0)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            do {
                currentUser = try JSONDecoder().decode(user.self, from: data)
                success = true
            
            } catch {
                print(error)
            }
            semaphore.signal()
            
        }.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        if success {
            print("Login success! Logging in user \(currentUser.email) {id=\(currentUser.id)}" )
            self.performSegue(withIdentifier: "loginToHome", sender: sender)
        }
        else {
            print("Login Failed")
            self.errMsg.text = "Login failed. Please try again."
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
            
            let dialogMessage = UIAlertController(title: "Account Created!", message: "Your account has been created!", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                self.performSegue(withIdentifier: "signUpToLogin", sender: self)
            })
            
            //Add OK and Cancel button to dialog message
            dialogMessage.addAction(ok)
            
            // Present dialog message to user
            self.present(dialogMessage, animated: true, completion: nil)
            
        }
        
    }
    
    func showAlertViewWithTitle(title: String, withMessage message: String) {
        
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction.init(title:"OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}



class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DJISDKManagerDelegate {
    
    var selected_contact = contact(firstName: "", lastName: "", id: 0)
    
    @IBOutlet weak var batteryLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DJISDKManager.registerApp(with: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //----------------------------------------------------------
    
    // DJISDKManagerDelegate Methods
    func productConnected(_ product: DJIBaseProduct?) {
//        if let _ = product {
//            print("Result True: let _ = product")
//            if DJISDKManager.product()!.isKind(of: DJIAircraft.self) {
//                print("Result True: DJISDKManager.product()!.isKind(of: DJIAircraft.self)")
//                print("Initializing flight controller...")
//                let flightController = (DJISDKManager.product()! as! DJIAircraft).flightController!
//                flightController.delegate = (self as! DJIFlightControllerDelegate)
//            } else { print("Result False: DJISDKManager.product()!.isKind(of: DJIAircraft.self)")}
//        } else { print("Result False: let _ = product")}
    }
    func productDisconnected() {
        NSLog("Product Disconnected")
    }
    
    func appRegisteredWithError(_ error: Error?) {
        
        if (error != nil) {
            print("Register App Failed!")
            self.showAlertViewWithTitle(title:"Register Error", withMessage: "Register App Failed!")
        } else {
            print("Register App Succeeded! Starting connection to product...")
            self.showAlertViewWithTitle(title:"Register App Successful", withMessage: "Register App Succeeded! Starting connection to product...")
            DJISDKManager.startConnectionToProduct()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        performSegue(withIdentifier: "homeToLogin", sender: sender)
    }
    
    // label to display drone status (if its connected>battery%, else>"disconnected")
    @IBOutlet weak var droneStatusLabel: UILabel!
    
    // This function is called when user click Check Drone Status
    @IBAction func droneStatusButton(_ sender: Any) {
        let batteryLevelKey = DJIBatteryKey(param: DJIBatteryParamChargeRemainingInPercent)
        DJISDKManager.keyManager()?.getValueFor(batteryLevelKey!, withCompletion: { [unowned self] (value: DJIKeyedValue?, error: Error?) in
            guard error == nil && value != nil else {
                // Insert graceful error handling here
                
                self.droneStatusLabel.text = "Error";
                return
            }
            // DJIBatteryParamChargeRemainingInPercent is associated with a uint8_t value
            self.droneStatusLabel.text = "\(value!.unsignedIntegerValue) %"
        })
    }
    
    @IBAction func callDroneButton(_ sender: Any) {
        // check if summoning is already in progress
        var deliveries: [delivery] = []
        var summon_in_progress = false
        
        guard let url = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/deliveries/search?user_id=" + String(currentUser.id)) else { return }
        
        var request = URLRequest(url: url)
        let semaphore = DispatchSemaphore(value: 0)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(deliveries_response.self, from: data)
                print("\n\nResult: \(result)")
                deliveries = result.deliveries
                
            } catch {
                print(error)
            }
            
            semaphore.signal()
            }.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        print("\n\nDeliveries: \(deliveries)")
        
        var message = ""
        for delivery in deliveries {
            if delivery.status == "in_progress" || delivery.status == "requested" || delivery.status == "accepted" || delivery.status == "confirmed" {
                if delivery.sender.id == delivery.receiver.id {
                    message = "Your drone is already on its way! Check its status from the Deliveries page."
                    print(message)
                    summon_in_progress = true
                } else {
                    message = "A delivery is already in progress! Please try again later."
                    print(message)
                    summon_in_progress = true
                }
            }
        }
        
        if !summon_in_progress {
            performSegue(withIdentifier: "homeToCallDrone", sender: sender)
        } else {
            self.showAlertViewWithTitle(title:"Drone Unavailable", withMessage: message)
        }
    }
    
    @IBAction func sendDroneButton(_ sender: Any) {
        
        // Check if delivery is already in progress
        var deliveries: [delivery] = []
        var delivery_in_progress = false
        
        guard let url = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/deliveries/search?user_id=" + String(currentUser.id)) else { return }
        
        var request = URLRequest(url: url)
        let semaphore = DispatchSemaphore(value: 0)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(deliveries_response.self, from: data)
                print("\n\nResult: \(result)")
                deliveries = result.deliveries
                
            } catch {
                print(error)
            }
            
            semaphore.signal()
            }.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        print("\n\nDeliveries: \(deliveries)")
        
        var message = ""
        for delivery in deliveries {
            if delivery.status == "in_progress" || delivery.status == "requested" || delivery.status == "accepted" || delivery.status == "confirmed" {
                if delivery.sender.id == delivery.receiver.id {
                    message = "Your drone is already on its way! Check its status from the Delivery Tracker."
                    print(message)
                    delivery_in_progress = true
                } else {
                    message = "A delivery is already in progress! Please try again later."
                    print(message)
                    delivery_in_progress = true
                }
            }
        }
        
        if delivery_in_progress {
            self.showAlertViewWithTitle(title:"Drone Unavailable", withMessage: message)
        } else {
            //----------------------------
            // post delivery
            var recipient = selected_contact
            print("Recipient: \(recipient)")
        
            let dict = ["drone_id" : 0, "status" : "requested", "origin": ["latitude" : 0, "longitude" : 0], "sender_id" : currentUser.id, "receiver_id" : recipient.id] as [String : Any]
        
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else { return }
        
            guard let url2 = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/deliveries") else { return }
        
            var statusCode = 0
            var request2 = URLRequest(url: url2)
            request2.httpMethod = "POST"
            request2.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request2.httpBody = jsonData as Data
            request2.timeoutInterval = 10
            let semaphore2 = DispatchSemaphore(value: 0)
        
            print("Starting URL session")
            let session2 = URLSession.shared
            session2.dataTask(with: request2) { (data, response, error) in
                
                if let httpResponse = response as? HTTPURLResponse {
                    print(response)
                    statusCode = httpResponse.statusCode
                }
                semaphore2.signal()
                }.resume()
            _ = semaphore2.wait(timeout: DispatchTime.distantFuture)
            print("Status Code: \(statusCode)")
        
            if statusCode == 201 {
                self.showAlertViewWithTitle(title:"Drone Request Sent", withMessage: "Your delivery request has been sent to \(recipient.firstName)! Check Pending Deliveries for updates.")
            }
            else {
                self.showAlertViewWithTitle(title:"Delivery Error", withMessage: "An unexpected error occurred. Please try again later.")
            }
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
    
    //CONTACTS
    var contactNames = [String]()
    var contacts = [contact]()
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var contactsTable: UITableView!
    @IBOutlet weak var confirmationLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        let semaphore = DispatchSemaphore(value: 0)
        guard let url = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/users/" + String(currentUser.id)) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(user_with_contacts.self, from: data)
                print("Result: \(result)")
                self.contacts = result.contacts
                
            } catch {
                print(error)
            }
            
            semaphore.signal()
            }.resume()
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        for contact in contacts {
            print(contact.firstName + " " + contact.lastName)
            contactNames.append(contact.firstName + " " + contact.lastName)
        }
    }
    
    //TABLE FUNCTION
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return(contactNames.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let contact_cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        contact_cell.textLabel?.text = contactNames[indexPath.row]
        
        return(contact_cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected_contact = self.contacts[indexPath.row]
        print("Selected contact \(selected_contact)")
    }
}

// CONTACTS PAGE
class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var contactNames = [String]()
    var contacts = [contact]()
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var contactsTable: UITableView!
    @IBOutlet weak var confirmationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        let semaphore = DispatchSemaphore(value: 0)
        guard let url = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/users/" + String(currentUser.id)) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(user_with_contacts.self, from: data)
                print("Result: \(result)")
                self.contacts = result.contacts
                
            } catch {
                print(error)
            }
            
            semaphore.signal()
            }.resume()
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        for contact in contacts {
            print(contact.firstName + " " + contact.lastName)
            contactNames.append(contact.firstName + " " + contact.lastName)
        }
    }
    
    //TABLE FUNCTION
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return(contactNames.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let contact_cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        contact_cell.textLabel?.text = contactNames[indexPath.row]
        
        return(contact_cell)
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
        
        let dict = ["user_email_1":currentUser.email, "user_email_2": email.text!] as [String : Any]
        
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
            viewWillAppear(true)
        }
        else {
            confirmationLabel.text! = "Unable to add contact. Please try again later."
            print("New contact request failed")
        }
    }
}

// CALL DRONE PAGE
class CallDroneViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, DJISDKManagerDelegate {
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var statusLabel: UILabel!
    
   // Code for waypoints in picker view-------------------------------------
    // Stony Brook  42.3165, -71.1045
    let waypoint1 = MKPointAnnotation()
    let waypoint2 = MKPointAnnotation()
    let waypoint3 = MKPointAnnotation()
    let waypoint4 = MKPointAnnotation()
    let waypoints = ["Stony Brook - NW Corner","Stony Brook - SE Corner","Stony Brook - NE Corner", "Stony Brook - SW Corner"]
    
    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.3165, longitude: -71.1045), span: MKCoordinateSpanMake(0.001, 0.001))
    
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
        DJISDKManager.registerApp(with: self)
    }
    //----------------------------------------------------------
    
    // DJISDKManagerDelegate Methods
    func productConnected(_ product: DJIBaseProduct?) {
//        if let _ = product {
//            print("Result True: let _ = product")
//            if DJISDKManager.product()!.isKind(of: DJIAircraft.self) {
//                print("Result True: DJISDKManager.product()!.isKind(of: DJIAircraft.self)")
//                print("Initializing flight controller...")
//                let flightController = (DJISDKManager.product()! as! DJIAircraft).flightController!
//                flightController.delegate = (self as! DJIFlightControllerDelegate)
//            } else { print("Result False: DJISDKManager.product()!.isKind(of: DJIAircraft.self)")}
//        } else { print("Result False: let _ = product")}
    }
    func productDisconnected() {
        NSLog("Product Disconnected")
    }
    
    func appRegisteredWithError(_ error: Error?) {
        
        if (error != nil) {
            print("Register App Failed!")
        } else {
            print("Register App Succeeded! Starting connection to product...")
            DJISDKManager.startConnectionToProduct()
        }
    }
    //----------------------------------------------------------
    func showAlertViewWithTitle(title: String, withMessage message: String) {
        
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction.init(title:"OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //Initialization ----------------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
        
        guard let connectedKey = DJIProductKey(param: DJIParamConnection) else {
            NSLog("Error creating the connectedKey")
            return;
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            DJISDKManager.keyManager()?.startListeningForChanges(on: connectedKey, withListener: self, andUpdate: { (oldValue: DJIKeyedValue?, newValue : DJIKeyedValue?) in
                if newValue != nil {
                    if newValue!.boolValue {
                        // At this point, a product is connected so we can show it.
                        
                        // UI goes on MT.
                        DispatchQueue.main.async {
                            self.productConnected(DJISDKManager.product())
                        }
                    }
                }
            })
            DJISDKManager.keyManager()?.getValueFor(connectedKey, withCompletion: { (value:DJIKeyedValue?, error:Error?) in
                if let unwrappedValue = value {
                    if unwrappedValue.boolValue {
                        // UI goes on MT.
                        DispatchQueue.main.async {
                            self.productConnected(DJISDKManager.product())
                        }
                    }
                }
            })
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        //NW corner 42.31687, -71.104768
        waypoint1.coordinate = CLLocationCoordinate2D(latitude: 42.31687, longitude: -71.104768)
        waypoint1.title = "Stony Brook - NW Corner"
        map.addAnnotation(waypoint1)
        
        //SE corner 42.31644, -71.10438
        waypoint2.coordinate = CLLocationCoordinate2D(latitude: 42.31644, longitude: -71.10438)
        waypoint2.title = "Stony Brook - SE Corner"
        map.addAnnotation(waypoint2)
        
        //NE corner 42.31685, -71.1042
        waypoint3.coordinate = CLLocationCoordinate2D(latitude: 42.31685, longitude: -71.1042)
        waypoint3.title = "Stony Brook - NE Corner"
        map.addAnnotation(waypoint3)
        
        //SW corner  42.3165, -71.10475
        waypoint4.coordinate = CLLocationCoordinate2D(latitude: 42.3165, longitude: -71.10475)
        waypoint4.title = "Stony Brook - SW Corner"
        map.addAnnotation(waypoint4)
        
        map.setRegion(region, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //DJISDKManager.registerApp(with: self)
    }
    //----------------------------------------------------------
    
    
    // Buttons ----------------------------------------------------------
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "callDroneToHome", sender: sender)
    }
    
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var callCancel: UIButton!
    
    var waypoint1_latitude = 0.0
    var waypoint1_longitude = 0.0
    var waypoint2_latitude = 0.0
    var waypoint2_longitude = 0.0
    
    @IBAction func callDroneButton(_ sender: Any) {
        print("Call drone button pressed...")
        
        if waypoints[pickerView.selectedRow(inComponent: 0)] == "Stony Brook - NW Corner" {
            waypoint1_latitude = 42.31687
            waypoint1_longitude = -71.104768
            waypoint2_latitude = waypoint1_latitude
            waypoint2_longitude = waypoint1_longitude
        } else if waypoints[pickerView.selectedRow(inComponent: 0)] == "Stony Brook - SE Corner" {
            waypoint1_latitude = 42.31644
            waypoint1_longitude = -71.10438
            waypoint2_latitude = waypoint1_latitude
            waypoint2_longitude = waypoint1_longitude
        } else if waypoints[pickerView.selectedRow(inComponent: 0)] == "Stony Brook - NE Corner" {
            waypoint1_latitude = 42.31685
            waypoint1_longitude = -71.1042
            waypoint2_latitude = waypoint1_latitude
            waypoint2_longitude = waypoint1_longitude
        } else if waypoints[pickerView.selectedRow(inComponent: 0)] == "Stony Brook - SW Corner" {
            waypoint1_latitude = 42.3165
            waypoint1_longitude = -71.10475
            waypoint2_latitude = waypoint1_latitude
            waypoint2_longitude = waypoint1_longitude
        }
        
//        guard let droneLocationKey = DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation) else { return }
//        print("Drone Location Key: \(droneLocationKey)")
//
//        guard let keyManager = DJISDKManager.keyManager() else {
//            label2.text = "Couldn't get the keyManager"
//            return
//        }
//        label2.text = "Key Manager: \(keyManager)"
//
//        // This isn't working?? Probably because nothing is connected
//        guard let droneLocationValue = keyManager.getValueFor(droneLocationKey) else {
//            label1.text = "drone location value failed"
//            return
//        }
//        print("Drone Location Value: \(droneLocationValue)")
//        label1.text = "Drone Location Value: \(droneLocationValue)"
//
//        let droneLocation = droneLocationValue.value as! CLLocation
//        let origin_waypoint = DJIWaypoint(coordinate: droneLocation.coordinate)
        
         //Once the above works, use this dict to reference drone location. for now testing with dummy data
        let dict = ["drone_id" : 0, "status" : "in_progress", "origin": ["latitude" : 0, "longitude" : 0], "destination" : ["latitude" : waypoint1_latitude, "longitude" : waypoint1_longitude], "sender_id" : currentUser.id, "receiver_id" : currentUser.id] as [String : Any]
        //let dict = ["drone_id" : 0, "status" : "in_progress", "origin": ["latitude" : 0, "longitude" : 0], "destination" : ["latitude" : lat, "longitude" : long], "sender_id" : currentUser.id, "receiver_id" : currentUser.id] as [String : Any]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else { return }
        
        guard let url = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/deliveries") else { return }
        
        var statusCode = 0
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData as Data
        request.timeoutInterval = 10
        let semaphore = DispatchSemaphore(value: 0)
        
        print("Starting URL session")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                print(response)
                statusCode = httpResponse.statusCode
            }
            semaphore.signal()
        }.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        print("Status Code: \(statusCode)")
        
        if statusCode == 201 {
            
            initializeMission()
            
            let alert = UIAlertController(title: "Request Confirmed", message: "The drone is on its way!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (_)in
                self.performSegue(withIdentifier: "callDroneToHome", sender: self)
            })
            
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
   
        } else {
            self.showAlertViewWithTitle(title:"Request Failed", withMessage: "An unexpected error occurred. Please try again later.")
        }
    }
    
    // DJI Mission initialization ------------
    func initializeMission() {
        // This is assuming we always have a delivery, if we use the waypoints
        // from above then we can just pass them in to the mission
        
        // Create waypoint from origin
        let coordinate1 = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(waypoint1_latitude), longitude: CLLocationDegrees(waypoint1_longitude))
        let waypoint1 = DJIWaypoint.init(coordinate: coordinate1)
        
        // Create waypoint from destination
        let coordinate2 = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(waypoint2_latitude), longitude: CLLocationDegrees(waypoint2_longitude))
        let waypoint2 = DJIWaypoint.init(coordinate: coordinate2)
        
        // Add the waypoints to a mission
        var djiMission = DJIMutableWaypointMission()
        djiMission.add(waypoint1)
        djiMission.add(waypoint2)
        
        // 4. Configure the mission
        djiMission.finishedAction = DJIWaypointMissionFinishedAction.noAction
        djiMission.autoFlightSpeed = 2
        djiMission.maxFlightSpeed = 4
        djiMission.headingMode = .auto
        djiMission.flightPathMode = .normal
        
        // 5. Validate our mission
        if let error = djiMission.checkParameters() {
            label2.text = "Waypoint Mission parameters are invalid: \(error.localizedDescription)"
            return
        }
        
        // We need to get the mission operator from mission control
        // Not really sure about this syntax
        let missionControl = DJISDKManager.missionControl()
        if(missionControl == nil) {
            label2.text = label2.text ?? "" + " " + "Invalid mission control"
        }
        
        let waypointMissionOperator = missionControl!.waypointMissionOperator()
        
        // 6.
        if let error = waypointMissionOperator.load(djiMission) {
            label2.text = label2.text ?? "" + " " + error.localizedDescription
        }
        
        // 7.
        waypointMissionOperator.addListener(toUploadEvent: self, with: DispatchQueue.main) { error in
            self.label2.text = self.label2.text ?? "" + " " + "Upload"
            if error.currentState.rawValue == 5 {
                //                    self.state = .flying
                //                    self.startMission()
            }
        }
        
        // 8.
        waypointMissionOperator.uploadMission() { error in
            if let error = error {
                self.label2.text = self.label2.text ?? "" + " " + "upload error: " + error.localizedDescription
            } else {
                self.label2.text = self.label2.text ?? "" + " " + "Upload finished"
                //                    self.state = .flying
            }
        }
        
        // 9.
        waypointMissionOperator.startMission(completion: { error in
            if let error = error {
                 self.label2.text = self.label2.text ?? "" + " " + "Error starting mission" + error.localizedDescription
            }
        })
    }
}


// DELIVERIES PAGE
class DeliveriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var timer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        get_deliveries()
        // start timer to make GET deliveries request every 2 seconds
        newBackgroundTimer()
    }
    
    func newBackgroundTimer() -> Void {
        DispatchQueue.global(qos: .background).async {
            
            // timer calls function check_deliveries every 2 seconds
            // this function checks for new delivery requests
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.check_deliveries), userInfo: nil, repeats: true)
            let runLoop = RunLoop.current
            runLoop.add(self.timer!, forMode: .defaultRunLoopMode)
            runLoop.run()
        }
    }
    
    @IBOutlet weak var deliveryTable: UITableView!
    @IBOutlet weak var requestTable: UITableView!
    
    // this function GETs all deliveries for the user and checks for new delivery requests
    // if there's a new delivery request found, user is notified
    
    @objc func check_deliveries() {
        get_deliveries() // this function gets all deliveries and store in unfiltered_deliveries
        
        for delivery in requests {
            
            // confirm this is person on receiving side-> notify them, else, ignore
            if delivery.receiver.id == currentUser.id {
                
                currentDeliveryId = delivery.id
                
                // Declare Alert message
                let dialogMessage = UIAlertController(title: "New Delivery Request", message: "New delivery request from \(delivery.sender.firstName). Would you like to accept this delivery?", preferredStyle: .alert)
                
                // Create OK button with action handler
                let accept = UIAlertAction(title: "Accept", style: .default, handler: { (action) -> Void in
                    currentDeliveryId = delivery.id
                    if self.timer != nil {
                        self.timer?.invalidate()
                        self.timer = nil
                    }
                    self.performSegue(withIdentifier: "deliveriesToAccept", sender: self)
                    print("Accept button tapped")
                    
                })
                
                // Create Cancel button with action handlder
                let decline = UIAlertAction(title: "Decline", style: .cancel) { (action) -> Void in
                    
                    print("Decline button tapped")
                    
                    let dict = ["status" : "cancelled"] as [String : Any]
                    guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else { return }
                    guard let url = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/deliveries/" + String(delivery.id)) else { return }
                    var statusCode = 0
                    var request = URLRequest(url: url)
                    request.httpMethod = "PUT"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = jsonData as Data
                    request.timeoutInterval = 10
                    let semaphore = DispatchSemaphore(value: 0)
                    
                    let session = URLSession.shared
                    session.dataTask(with: request) { (data, response, error) in
                        
                        if let httpResponse = response as? HTTPURLResponse {
                            print(response)
                            statusCode = httpResponse.statusCode
                        }
                        semaphore.signal()
                        }.resume()
                    _ = semaphore.wait(timeout: DispatchTime.distantFuture)
                    print("Status Code: \(statusCode)")
                    
                    //stop the timer
                    if self.timer != nil {
                        self.timer?.invalidate()
                        self.timer = nil
                    }
                    self.performSegue(withIdentifier: "deliveriesToStatus", sender: self)
                }
                
                //Add OK and Cancel button to dialog message
                dialogMessage.addAction(accept)
                dialogMessage.addAction(decline)
                
                // Present dialog message to user
                self.present(dialogMessage, animated: true, completion: nil)
            }
        }
        
        for delivery in accepted {
            
            // confirm that current user is the sender, notify them that receiver has accepted delivery
            if delivery.sender.id == currentUser.id {
                
                currentDeliveryId = delivery.id
                // Declare Alert message
                let dialogMessage = UIAlertController(title: "Delivery Accepted", message: "\(delivery.receiver.firstName) has accepted your delivery! Prepare the package and click Launch Drone when the drone is ready for takeoff.", preferredStyle: .alert)
                
                // Create OK button with action handler
                let ok = UIAlertAction(title: "Launch Drone", style: .default, handler: { (action) -> Void in
                    if self.timer != nil {
                        self.timer?.invalidate()
                        self.timer = nil
                    }
                    
                    print("Drone mission launced")
                    
                    let dict = ["status" : "in_progress"] as [String : Any]
                    guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else { return }
                    guard let url = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/deliveries/" + String(delivery.id)) else { return }
                    var statusCode = 0
                    var request = URLRequest(url: url)
                    request.httpMethod = "PUT"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = jsonData as Data
                    request.timeoutInterval = 10
                    let semaphore = DispatchSemaphore(value: 0)
                    
                    let session = URLSession.shared
                    session.dataTask(with: request) { (data, response, error) in
                        
                        if let httpResponse = response as? HTTPURLResponse {
                            print(response)
                            statusCode = httpResponse.statusCode
                        }
                        semaphore.signal()
                        }.resume()
                    _ = semaphore.wait(timeout: DispatchTime.distantFuture)
                    
                    //TODO: INITIALIZE DRONE MISSION
                    
                    //stop the timer
                    if self.timer != nil {
                        self.timer?.invalidate()
                        self.timer = nil
                    }
                    self.performSegue(withIdentifier: "deliveriesToStatus", sender: self)
                })
                
                //Add OK and Cancel button to dialog message
                dialogMessage.addAction(ok)
                
                // Present dialog message to user
                self.present(dialogMessage, animated: true, completion: nil)
                
            }
            
        }
    }
    
    var unfiltered_deliveries: [delivery] = [] // all deliveries retruned from initial get request
    var requests: [delivery] = []
    var accepted: [delivery] = []
    var confirmed: [delivery] = []
    var done: [delivery] = []   // filtered complete/canceled deliveries
    var in_progress: [delivery] = []
    var in_progress_display: [String] = [] // what gets displayed for in progress deliveries
    var done_display: [String] = [] // what gets displayed for done deliveries
    
    
    func get_deliveries() {
        
        let semaphore = DispatchSemaphore(value: 0)
        guard let url = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/deliveries/search/?user_id=" + String(currentUser.id)) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            print(data)
            do {
                let result = try JSONDecoder().decode(deliveries_response.self, from: data)
                print("Result: \(result)")
                self.unfiltered_deliveries = result.deliveries
                
            } catch {
                print(error)
            }
            
            semaphore.signal()
            }.resume()
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        for delivery in unfiltered_deliveries {
            
            print("\nDelivery \(delivery.id) - \(delivery.status)")
            
            if delivery.status == "requested" {
                requests.append(delivery)
                in_progress.append(delivery)
            } else if delivery.status == "accepted" {
                currentDeliveryId = delivery.id
                accepted.append(delivery)
                in_progress.append(delivery)
            } else if delivery.status == "confirmed" {
                confirmed.append(delivery)
                in_progress.append(delivery)
            } else if delivery.status == "in_progress" {
                in_progress.append(delivery)
            } else {
                done.append(delivery)
                
                // check if it's a summon to determine what to display
                if delivery.sender.id == delivery.receiver.id {
                    done_display.append("Call drone request: " + delivery.status)
                } else {
                    done_display.append("Delivery " + delivery.status + ": " + delivery.sender.firstName + ">" + delivery.receiver.firstName)
                }
            }
        }
        
        for delivery in in_progress {
            // check if it's a summon to determine what to display
            if delivery.sender.id == delivery.receiver.id {
                in_progress_display.append("Call drone request in progress")
            } else {
                in_progress_display.append("In progress: " + delivery.sender.firstName + " >> " + delivery.receiver.firstName)
            }
        }
        
        print("Requested: \(requests)")
        print("Accepted: \(accepted)")
        print("Confirmed: \(confirmed)")
        print("In Progress: \(in_progress)")
        print("Done: \(done)")
        print("In Progress Deliveries (Labels):")
        for i in in_progress_display {
            print(i)
        }
        print("Done Deliveries (Labels):")
        for i in done_display {
            print(i)
        }
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if (tableView == deliveryTable) {
            return(done_display.count)
        }
        
        else  {
            return(in_progress_display.count)
        }
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let delivery_cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        if (tableView == deliveryTable) {
            delivery_cell.textLabel?.text = done_display[indexPath.row]
            return delivery_cell
        }
        else {
            delivery_cell.textLabel?.text = in_progress_display[indexPath.row]
            return(delivery_cell)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func statusButton(_ sender: Any) {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        
        if in_progress.count >= 1 {
            currentDeliveryId = in_progress[0].id
            performSegue(withIdentifier: "deliveriesToStatus", sender: sender)
        } else {
            self.showAlertViewWithTitle(title:"Error", withMessage: "No deliveries in progress.")
        }
        
    }
    
    func showAlertViewWithTitle(title: String, withMessage message: String) {
        
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction.init(title:"OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        performSegue(withIdentifier: "deliveriesToHome", sender: sender)
    }
}


// ACCEPT DELIVERY PAGE
class AcceptDeliveryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, DJISDKManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    // Code for waypoints in picker view-------------------------------------
    // Stony Brook  42.3165, -71.1045
    let waypoint1 = MKPointAnnotation()
    let waypoint2 = MKPointAnnotation()
    let waypoint3 = MKPointAnnotation()
    let waypoint4 = MKPointAnnotation()
    let waypoints = ["Stony Brook - NW Corner","Stony Brook - SE Corner","Stony Brook - NE Corner", "Stony Brook - SW Corner"]
    
    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.3165, longitude: -71.1045), span: MKCoordinateSpanMake(0.001, 0.001))
    
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
        DJISDKManager.registerApp(with: self)
    }
    //----------------------------------------------------------
    
    // DJISDKManagerDelegate Methods
    func productConnected(_ product: DJIBaseProduct?) {
        if let _ = product {
            print("Result True: let _ = product")
            if DJISDKManager.product()!.isKind(of: DJIAircraft.self) {
                print("Result True: DJISDKManager.product()!.isKind(of: DJIAircraft.self)")
                print("Initializing flight controller...")
                let flightController = (DJISDKManager.product()! as! DJIAircraft).flightController!
                flightController.delegate = (self as! DJIFlightControllerDelegate)
            } else { print("Result False: DJISDKManager.product()!.isKind(of: DJIAircraft.self)")}
        } else { print("Result False: let _ = product")}
    }
    func productDisconnected() {
        NSLog("Product Disconnected")
    }
    
    func appRegisteredWithError(_ error: Error?) {
        
        if (error != nil) {
            print("Register App Failed!")
        } else {
            print("Register App Succeeded! Starting connection to product...")
            DJISDKManager.startConnectionToProduct()
        }
    }
    //----------------------------------------------------------
    func showAlertViewWithTitle(title: String, withMessage message: String) {
        
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction.init(title:"OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //Initialization ----------------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        //NW corner 42.31687, -71.104768
        waypoint1.coordinate = CLLocationCoordinate2D(latitude: 42.31687, longitude: -71.104768)
        waypoint1.title = "Stony Brook - NW Corner"
        map.addAnnotation(waypoint1)
        
        //SE corner 42.31644, -71.10438
        waypoint2.coordinate = CLLocationCoordinate2D(latitude: 42.31644, longitude: -71.10438)
        waypoint2.title = "Stony Brook - SE Corner"
        map.addAnnotation(waypoint2)
        
        //NE corner 42.31685, -71.1042
        waypoint3.coordinate = CLLocationCoordinate2D(latitude: 42.31685, longitude: -71.1042)
        waypoint3.title = "Stony Brook - NE Corner"
        map.addAnnotation(waypoint3)
        
        //SW corner  42.3165, -71.10475
        waypoint4.coordinate = CLLocationCoordinate2D(latitude: 42.3165, longitude: -71.10475)
        waypoint4.title = "Stony Brook - SW Corner"
        map.addAnnotation(waypoint4)
        
        map.setRegion(region, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
       // DJISDKManager.registerApp(with: self)
    }
    //----------------------------------------------------------
    
    @IBAction func confirmButton(_ sender: Any) {
        var lat: Float = 0
        var long: Float = 0
        
        if waypoints[pickerView.selectedRow(inComponent: 0)] == "Stony Brook - NW Corner" {
            lat = 42.31687
            long = -71.104768
        } else if waypoints[pickerView.selectedRow(inComponent: 0)] == "Stony Brook - SE Corner" {
            lat = 42.31644
            long = -71.10438
        } else if waypoints[pickerView.selectedRow(inComponent: 0)] == "Stony Brook - NE Corner" {
            lat = 42.31685
            long = -71.1042
        } else if waypoints[pickerView.selectedRow(inComponent: 0)] == "Stony Brook - SW Corner" {
            lat = 42.3165
            long = -71.10475
        }
        
        let dest_waypoint = DJIWaypoint(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long)))
        
        let dict = ["status" : "accepted",  "destination" : ["latitude" : lat, "longitude" : long]] as [String : Any]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else { return }
        guard let url = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/deliveries/" + String(currentDeliveryId)) else { return }
        var statusCode = 0
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData as Data
        request.timeoutInterval = 10
        let semaphore = DispatchSemaphore(value: 0)
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                print(response)
                statusCode = httpResponse.statusCode
            }
            semaphore.signal()
            }.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        print("Status Code: \(statusCode)")
        
        if statusCode == 200 {
            let alert = UIAlertController(title: "Request Confirmed", message: "Delivery confirmed! The sender is preparing your package. Check its status on the Delivery Status page.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (_)in
                self.performSegue(withIdentifier: "acceptToStatus", sender: self)
            })
            
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.showAlertViewWithTitle(title:"Delivery Error", withMessage: "An unexpected error occurred. Please try again later.")
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        //cancel the delivery
        print("Decline button tapped")

        let dict = ["status" : "cancelled"] as [String : Any]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else { return }
        guard let url = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/deliveries/" + String(currentDeliveryId)) else { return }
        var statusCode = 0
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData as Data
        request.timeoutInterval = 10
        let semaphore = DispatchSemaphore(value: 0)

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in

            if let httpResponse = response as? HTTPURLResponse {
                print(response)
                statusCode = httpResponse.statusCode
            }
            semaphore.signal()
            }.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
}

// DELIVERY STATUS PAGE
class DeliveryStatusViewController: UIViewController {
    
    
    @IBOutlet weak var confirm: UIButton!
    @IBOutlet weak var sender: UILabel!
    @IBOutlet weak var receiver: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var created_at: UILabel!
    @IBOutlet weak var updated_at: UILabel!
    var d = delivery(id: 0, droneId: 0, origin: coordinates(latitude: 0, longitude: 0), destination: coordinates(latitude: 0, longitude: 0), status: "", sender: contact(firstName: "", lastName: "", id: 0), receiver: contact(firstName: "", lastName: "", id: 0), createdDate: "", updatedDate: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        print("\n\n\nCURRENT DELIVERY ID: \(currentDeliveryId) \n\n\n")
        
        confirm.isEnabled = false
        confirm.addTarget(self, action: #selector(DeliveryStatusViewController.buttonAction(_:)), for: .touchUpInside)
        
        let semaphore = DispatchSemaphore(value: 0)
        guard let url = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/deliveries/" + String(currentDeliveryId)) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            print(data)
            do {
                let result = try JSONDecoder().decode(delivery.self, from: data)
                print("Result: \(result)")
                self.d = result
                
            } catch {
                print(error)
            }
            
            semaphore.signal()
            }.resume()
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        self.sender.text = d.sender.firstName + " " + d.sender.lastName
        self.receiver.text = d.receiver.firstName + " " + d.receiver.lastName
        self.created_at.text = d.createdDate
        self.updated_at.text = d.updatedDate
        
        if d.status == "requested" {
            self.status.text = "Waiting on receiver to accept the request."
        } else if d.status == "accepted" {
            self.status.text = "Request accepted by receiver. Sender is preparing package."
        } else if d.status == "in_progress" {
            
            // enable the confirm button if a delivery is in progress and the active user is the receiver
            if d.receiver.id == currentUser.id {
                self.confirm.isEnabled = true
            }
            
            self.status.text = "Drone en route"
        } else {
            self.status.text = d.status
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "statusToDeliveries", sender: self)
    }
    
    @objc func buttonAction(_ sender:UIButton!) {
        let dict = ["status" : "completed"] as [String : Any]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else { return }
        guard let url = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/deliveries/" + String(currentDeliveryId)) else { return }
        var statusCode = 0
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData as Data
        request.timeoutInterval = 10
        let semaphore = DispatchSemaphore(value: 0)
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                print(response)
                statusCode = httpResponse.statusCode
            }
            semaphore.signal()
            }.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        print("Status Code: \(statusCode)")
        viewWillAppear(true)
    }
    
}
