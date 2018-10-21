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

//STRUCTS: based off yaml
struct drone: Decodable {
    var id: Int
    var position: coordinates
    var batterPercent: Int
    var inFlight: String
}

struct coordinates: Decodable {
    var latitude: Float
    var longitude: Float
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
    var createdDate: Int
    var updatedDate: Int
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



class HomeViewController: UIViewController {
    
    @IBOutlet weak var batteryLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        performSegue(withIdentifier: "homeToLogin", sender: sender)
    }
    
    @IBAction func callDroneButton(_ sender: Any) {
        // check if summoning is already in progress
        // ** THIS HASNT BEEN TESTED
        
        var deliveries: [delivery] = []
        var in_progress = false
        
        guard let url = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/deliveries?userId=" + String(currentUser.id)) else { return }
        
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
                deliveries = result.deliveries
                
            } catch {
                print(error)
            }
            
            semaphore.signal()
            }.resume()
        
        print("Deliveries: \(deliveries)")
        
        for delivery in deliveries {
            if delivery.sender.id == delivery.receiver.id && delivery.status == "In Progress" {
                self.showAlertViewWithTitle(title:"Drone Request In Progress", withMessage: "Your drone is on its way! Check its status from the Delivery Tracker.")
                in_progress = true
            }
        }
        
        if !in_progress {
            performSegue(withIdentifier: "homeToCallDrone", sender: sender)
        }
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
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var statusLabel: UILabel!
    
   // Code for waypoints in picker view-------------------------------------
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
    
    //Initialization ----------------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
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
        DJISDKManager.registerApp(with: self)
    }
    //----------------------------------------------------------
    
    
    // Buttons ----------------------------------------------------------
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "callDroneToHome", sender: sender)
    }
    
    @IBOutlet weak var callCancel: UIButton!
    @IBAction func callDroneButton(_ sender: Any) {
        
        var lat: Float = 0
        var long: Float = 0
        
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
        
        let dest_waypoint = DJIWaypoint(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long)))
        guard let droneLocationKey = DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation) else { return }
            
        guard let droneLocationValue = DJISDKManager.keyManager()?.getValueFor(droneLocationKey) else { return }
            
        let droneLocation = droneLocationValue.value as! CLLocation
        let origin_waypoint = DJIWaypoint(coordinate: droneLocation.coordinate)

    
        func initializeMission() {

            var djiMission = DJIMutableWaypointMission()

            let mission = djiMission
            djiMission.add(origin_waypoint)
            djiMission.add(dest_waypoint)

//            // 4.
//            djiMission.finishedAction = DJIWaypointMissionFinishedAction.noAction
//            djiMission.autoFlightSpeed = 2
//            djiMission.maxFlightSpeed = 4
//            djiMission.headingMode = .auto
//            djiMission.flightPathMode = .normal
//
//            // 5.
//            if let error = djiMission.checkParameters() {
//                print("Waypoint Mission parameters are invalid: \(error.localizedDescription)")
//                return
//            }
//
//            // 6.
//            if let error = DJISmissionOperator.load(djiMission) {
//                print(error.localizedDescription)
//            }
//
//            // 7.
//            missionOperator.addListener(toUploadEvent: self, with: DispatchQueue.main) { error in
//                print("Upload")
//                if error.currentState.rawValue == 5 {
//                    self.state = .flying
//                    self.startMission()
//                }
//            }
//
//            // 8.
//            missionOperator.uploadMission() { error in
//                if let error = error {
//                    print("Upload error")
//                    print(error.localizedDescription)
//                } else {
//                    print("Upload finished")
//                    self.state = .flying
//                }
//            }
        }
        
    }
}


// DELIVERIES PAGE
class DeliveriesViewController: UIViewController {
    
    var unfiltered_deliveries: [delivery] = [] // all deliveries retruned from initial get request
    
    var deliveries: [delivery] = []         // filtered deliveries - for the delivery tracker table
    var deliveries_display: [String] = []   // what gets displayed for the delivery in the table view
    
    var requests: [delivery] = []           // filtered deliveries - for the pending delivery requests table
    var request_display: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let url = URL(string: "https://shielded-mesa-50019.herokuapp.com/api/deliveries?userId=" + String(currentUser.id)) else { return }
        
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
                self.unfiltered_deliveries = result.deliveries
                
            } catch {
                print(error)
            }
            
            semaphore.signal()
            }.resume()
        
        // split between Pending Requests and Delivery Tracker (history)
        /* delivery status is assumed to be one of:
            - Pending
            - In Progress
            - Cancelled
            - Complete
         */
        for delivery in unfiltered_deliveries {
            
            if delivery.status == "Pending" {
                requests.append(delivery)
                if delivery.sender.id == currentUser.id {
                    request_display.append("To: " + delivery.receiver.firstName)
                } else {
                    request_display.append("From: " + delivery.sender.firstName)
                }
            }
            else {
                
                if delivery.sender.id == delivery.receiver.id && delivery.status != "In Progress" { // completed or cancelled summon, we dont want to display it
                    continue
                
                } else {
                    
                    deliveries.append(delivery)
                    
                    if delivery.sender.id == delivery.receiver.id { // incomplete summon
                        deliveries_display.append("Drone request in progress")
                    } else {
                        
                        if delivery.sender.id == currentUser.id {
                            deliveries_display.append("To: " + delivery.receiver.firstName + " | Status: " + delivery.status)
                        } else {
                            deliveries_display.append("From: " + delivery.sender.firstName + " | Status: " + delivery.status)
                        }
                    }
                    
                }
            }
        }
        
        print("Deliver Tracker table data: \(deliveries)")
        print("Deliver Tracker table labels: \(deliveries_display)") // Array to get displayed in Display Tracker
        print("Pending Requests table data: \(requests)")
        print("Pending Requests table labels: \(request_display)") // Array to get displayed in Pending Requests
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    @IBAction func refreshButton(_ sender: Any) {
        viewWillAppear(true)
    }
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "deliveriesToHome", sender: sender)
    }
}
