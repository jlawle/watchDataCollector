//
//  InterfaceController.swift
//  watchSensorData-v1 WatchKit Extension
//
//  Created by John Lawler on 3/13/21.
//

// NOTE TO DISCUSS (CB): error that happened when you hit stop, (the app crashing) happens whenever you hit ANY
// button after the program begins recording (i.e same for when you try to add markers while it is recording)
// task for the night: mimic structs from this file to my own and get the recording gyroscope data to work
// without worryign about it continuing to record in the background, thought process is that I can slowly
// add in the connectivity and health stuff to see where the issue is occurring

// ALSO: the markers work perfectly fine when the app is not recoridng gyro data, and it logs it perfectly fine
// added an if(recording) condition around the marker func, so if you want to test markers w/o the recording button
// causing it to crash, just comment out the if condition and record the markers without hitting the record button

// CB: 4/18/21 added marker & show button, second screen with table, and corresponding action function. Added timeFormatter
//             function (a mod of the existing getTime() function) in the secondiInterfaceController, added rowController
//             class file for marker display table, changed record button formatting so text switched to "recording..."
//             when recording and back after stop for better readability

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
    var WKsession: HKWorkoutSession? = nil
    var builder: HKLiveWorkoutBuilder? = nil
    var motion = CMMotionManager()
    var frequency: Int = 60
    
    // Session data for saving
    var timeStamp = Date()
    var sensorData = [sensorParam]()
    
    // Array to store marker time data (CB)
    var markers = [markerMsg]()
    
    var recording: Bool = false     //CB
    
    
    
    // Buttons
    @IBOutlet var recordButton: WKInterfaceButton!
    @IBOutlet var stopButton: WKInterfaceButton!
    @IBOutlet var markerButton: WKInterfaceButton!      //CB
    @IBOutlet var showButton: WKInterfaceButton!        //CB
    


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
    
    // override that pushes to secondary screen when 'Show Markers' button is pushed
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        if segueIdentifier == "markerSegue" {
            return markers
        }
        print("returning nil")
        return nil
    }
    
    @IBAction func timeMarker() {       //CB
      //  if(recording) {
            markers.append(markerMsg(time: Date.init()))
      //  }
    }
    
    
    // Run completion function to handle closing workout session prior to
    // saving the data
    func stopGettingData(handler: @escaping(_ sessionDone: Bool) -> ()) {

        
        // Check to make sure session is not nil
        if (WKsession == nil){
            return
        }
        
        // stop device motion updates
        motion.stopDeviceMotionUpdates()
        
        // end our current workout session and builder
        WKsession!.end()
        builder!.endCollection(withEnd: Date()) { (success, error) in
            
            guard success else {
                // Handle erro
                fatalError("Unable to end builder data collection: \(String(describing: error))")
            }
            
            self.builder!.finishWorkout { (workout, error) in
                
                guard workout != nil else {
                    // Handle errors.
                    fatalError("Unable to finish builder workout: \(String(describing: error))")
                }
                
                DispatchQueue.main.async() {
                    // Update the user interface.
                }
            }
        }
        WKsession = nil
        handler(true)
    }
    
    
    
    @IBAction func stopRecording(){
        
       // motion.stopDeviceMotionUpdates()
        print("Stopped Recording...")
        
        // CB
        if(recording) {
            recordButton.setTitle("Record")
        }
        
        
        // Close session and wrap up data to send
        // Close session first so we know data is now available
        stopGettingData{ (sessionDone) in
            
            // build encoder, encode data to file
            
            
            
            
            
            
            
            
        }
        
        
        // Create completion handler to stop device updates and
        // workout session prior to sending data to io
        
        
    }

    // Function to perform action when button tapped
    @IBAction func startRecording(){
        //CB
        if(!recording) {
            recordButton.setTitle("Recording...")
        }
        
        recording = true                //CB
        
        print("Recording...")
//        let msg = "Starting watch recording"
//        let debugMsg = DebugMsg(time: getTime(), message: msg)
//        let session = WCSession.default
//        if session.activationState == .activated {
//            session.sendMessage(["debugMsg": debugMsg], replyHandler: nil, errorHandler: { error in print("error \(error)")})
//
//        }
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
                let output = sensorParam()
                
                output.time = Date()
                //output.gyrox =
                
                
              // Retrieve our sensor data and put it into an array
                output.gyrox = data!.rotationRate.x
                output.gyroy = data!.rotationRate.y
                output.gyroz = data!.rotationRate.z
                output.accx = data!.userAcceleration.x
                output.accy = data!.userAcceleration.y
                output.accz = data!.userAcceleration.z
                output.roll = data!.attitude.roll
                output.pitch = data!.attitude.pitch
                output.yaw = data!.attitude.yaw
//                output.gravx = data!.gravity.x
//                output.gravy= data!.gravity.y
//                output.gravz = data!.gravity.z
            
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
            WKsession = try HKWorkoutSession(healthStore: healthStore, configuration: workoutCfg)
        } catch {
            print(error)
            //fatalError("Unable to create the workout session!")
            WKsession = nil
            return
        }
        
        builder = WKsession?.associatedWorkoutBuilder()
        
        // Setup our session and builder
        WKsession?.delegate = self
        builder?.delegate = self
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: workoutCfg)

        // Start session and builder
        WKsession?.startActivity(with: Date())
        builder?.beginCollection(withStart: Date()) { (success, error) in
            guard success else {
                fatalError("Unable to begin builder collection of data: \(String(describing: error))")
            }
            // Indicate that the session has started.
        }
        
        
    }

    // Send iOS activation message
    func sendWakeMessage(){
        
        // Check for prior session start
//        if (session == nil){
//            return
//        }
            
       // if session.activationState == .activated && session.isReachable {
            
            
            
        
        
        
        
        
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
    
    // alteration to John's getTime function, to format a time string
    // based on the date passed to it, rather than the current date
    func timeFormatter(date: Date) -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let min = calendar.component(.minute, from: date)
        let sec = calendar.component(.second, from: date)
        // let nsec = calendar.component(.nanosecond, from: date)
        // removed nsec from format
        let time = "\(hour):\(min):\(sec)"
        
        return time
    }
    
    // WC needed method
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }

    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        
    }
    
   
    
}
