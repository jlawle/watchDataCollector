//
//  InterfaceController.swift
//  watchSensorData-v1 WatchKit Extension
//
//  Created by John Lawler on 3/13/21.
//

import WatchKit
import HealthKit
import Foundation
import CoreMotion
import WatchConnectivity
import os.log


class InterfaceController: WKInterfaceController, WCSessionDelegate, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        
    }
    
    
    
    // for background motion retrieval
    let queue = OperationQueue()
    let healthStore = HKHealthStore()
    let workoutCfg = HKWorkoutConfiguration()
    var session: HKWorkoutSession? = nil
    var builder: HKLiveWorkoutBuilder? = nil
    var motion = CMMotionManager()
    var frequency: Int = 60
    
    // Session data for saving
    var timeStamp = Date()
    var sensorData = [sensorParam]()
    
    
    
    
    // Buttons
    @IBOutlet var recordButton: WKInterfaceButton!
    @IBOutlet var stopButton: WKInterfaceButton!
    


    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        if(WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    @IBAction func stopRecording(){
        
       // motion.stopDeviceMotionUpdates()
        print("Stopped Recording...")
        
        
        
        
        // Create completion handler to stop device updates and
        // workout session prior to sending data to ios
        
        
        
        
        
    }

    // Function to perform action when button tapped
    @IBAction func startRecording(){
       
        print("Recording...")
        let msg = "Starting watch recording"
        let debugMsg = DebugMsg(time: getTime(), message: msg)
        let session = WCSession.default
        if session.activationState == .activated {
            session.sendMessage(["debugMsg": debugMsg], replyHandler: nil, errorHandler: { error in print("error \(error)")})
            
        }
        //session.sendMessage()
        
        
       retrieveSensorData()
    }
    
    
    func retrieveSensorData() {
        timeStamp = Date()
        
       
        // Start the workout Session for background updates
        startHKworkoutSession()
        
       
        
        // Make sure motion is available
        if !motion.isDeviceMotionAvailable {
            fatalError("Device motion not available.")
        }
        
        
        // Tells how often to check for a change in motion, every 1/60 second
        motion.deviceMotionUpdateInterval = 1.0/Double(frequency)
        
        // start retrieving motion updates
        motion.startDeviceMotionUpdates(to: OperationQueue.current!){ (data, err) in
            // error handling
            if err != nil {
                print("Error starting Device Updates: \(err!)")
            }
            
            // if data exists
            if data != nil {
                // string interprolation
                var output = sensorParam()
                
                output.time = Date()
                //output.gyrox =
                
                
              // Retrieve our sensor data and put it into an array
                output.gyrox = data!.rotationRate.x
                output.gyroy = data!.rotationRate.y
                output.gyroz = data!.rotationRate.z
                output.accx = data!.userAcceleration.x
                output.accy = data!.userAcceleration.y
                output.accz = data!.userAcceleration.z
                self.sensorData.append(output)
              
                // prints data to outpu
//                print("Time: \(time), g-x: \(gyrox) g-y: \(gyroy) g-z: \(gyroz)")
//                print("Time: \(time), a-x: \(accx) a-y: \(accy) a-z: \(accz)")
                
                
                
            }
        }
        
        
    }
    
    
    // Starts a new workout session prior to recording data
    func startHKworkoutSession() {
        workoutCfg.activityType = .walking
        workoutCfg.locationType = .indoor
        
        // Create the workout session
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: workoutCfg)
        } catch {
            print(error)
            //fatalError("Unable to create the workout session!")
            session = nil
            return
        }
        
        builder = session?.associatedWorkoutBuilder()
        
        // Setup our session and builder
        session?.delegate = self
        builder?.delegate = self
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: workoutCfg)

        // Start session and builder
        session?.startActivity(with: timeStamp)
        builder?.beginCollection(withStart: timeStamp) { (success, error) in
            guard success else {
                fatalError("Unable to begin builder collection of data")
            }
            // Indicate that the session has started.
        }
        
        
    }

    
    // retrieve the time
    func getTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let min = calendar.component(.minute, from: date)
        let sec = calendar.component(.second, from: date)
        let nsec = calendar.component(.nanosecond, from: date)
        
        let time = "\(hour):\(min):\(sec):\(nsec)"
        
        return time
        
        
    }
    
    // WC needed method
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }

    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        
    }
    
   
    
}
