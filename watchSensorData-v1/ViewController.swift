//
//  ViewController.swift
//  watchSensorData-v1
//
//  Created by John Lawler on 3/13/21.
//

import UIKit
import CoreMotion
import WatchConnectivity


class ViewController: UIViewController, WCSessionDelegate {

    var session: WCSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate();
        }
    }

    
    
    
    // Method to parse out different messages sent from the watch
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String : Any]) -> Void){
    
//        // if message is of type
//        if let biteMessage = message["biteCounted"] as? String {
//           
//        }
        
        // Test WC connection
        if let debugMsg = message["debugMsg"] as? String {
            print(debugMsg)
        }
    
        // Handle marker button calls and print, eventually save 
        if let marker = message["Markers"] as? String {
            // Save a marker at the given time provided
            print("Marker recieved!")
            print(marker)
        }
    }
    
    
    func session(_ session: WCSession, didReceive file: WCSessionFile){
        
    }
    
    
    // Methods needed for watchConnectivity
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}

}

