//
//  ViewController.swift
//  Homework #6
//
//  Created by d.igihozo on 4/12/23.
//

import UIKit
import CoreLocation
import WebKit
import MessageUI

class ViewController: UIViewController, CLLocationManagerDelegate, MFMessageComposeViewControllerDelegate {
    
    
    @IBOutlet var distanceLabel: UILabel?
    @IBOutlet var webView: WKWebView?
    
    
    let locationManager: CLLocationManager = CLLocationManager()
    var startlocation: CLLocation!
    
    
    let kigaliLatitude: CLLocationDegrees = -1.935114
    let kigaliLongitude: CLLocationDegrees = 30.082111
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else {
            return
        }
        
        let kigali: CLLocation = CLLocation(latitude: kigaliLatitude, longitude: kigaliLongitude)
        let distanceInMeters: CLLocationDistance = kigali.distance(from: currentLocation)
        let distanceInMiles: Double = (distanceInMeters/1609.344)
        
        if distanceInMiles < 3 {
           locationManager.stopUpdatingLocation()
           distanceLabel?.text = "Enjoy the land of a thousand hills!"
       } else {
           let formatter = NumberFormatter()
           formatter.locale = Locale(identifier: "en_US_POSIX")
           formatter.numberStyle = .decimal
           formatter.maximumFractionDigits = 3
           
           let distanceInMeters = currentLocation.distance(from: kigali)
           let distanceInMiles = distanceInMeters / 1609.344 // 1 mile = 1609.344 meters
           
           let formattedDistance = formatter.string(from: NSNumber(value: distanceInMiles)) ?? ""
           distanceLabel?.text = "\(formattedDistance) miles to Kigali, Rwanda"
               }
           }
    
    
    //site action method
    @IBAction func openSite(_ sender: Any) {
           if let url = URL(string: "https://www.visitrwanda.com/"){
               UIApplication.shared.open(url, options:[:])
           }
       }
    
    // Button action method
    @IBAction func sendMessage(_ sender: UIButton) {
        
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.body = "Enter your message here"
            messageVC.recipients = ["1234567890"]
            messageVC.messageComposeDelegate = self
            present(messageVC, animated: true, completion: nil)
        }
        else {
        // Handle case where user's device can't send messages
            print("Can't send messages")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startlocation = nil
       
        //to make sure the webView outlet is not nil before trying to load a request
        if let webView = webView, let myURL = URL(string: "https://www.visitrwanda.com/") {
            let myRequest = URLRequest(url: myURL)
            webView.load(myRequest)
        } else {
            print("Invalid URL or webView is nil")
        }
        
        // check if device can send text messages
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.body = "Hello, this is a test message!"
            messageVC.recipients = ["1234567890"] // set recipient phone number(s) here
            messageVC.messageComposeDelegate = self
            present(messageVC, animated: true, completion: nil)
        } else {
            print("This device cannot send text messages")
        }
    }
    
    
    //MFMessageComposeViewControllerDelegate method
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .cancelled:
            print("Message was cancelled")
        case .sent:
            print("Message was sent")
        case .failed:
            print("Message failed")
        @unknown default:
            fatalError()
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        }
    
}
