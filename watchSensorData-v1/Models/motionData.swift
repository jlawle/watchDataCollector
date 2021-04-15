//
//  motionData.swift
//  watchSensorData-v1
//
//  Created by John Lawler on 4/5/21.
//

import Foundation
import CoreMotion
import UIKit

// data sent from the watch
struct sensorParam {
    var time: Date?
    
    // gyro values
    var gyrox: Double?
    var gyroy: Double?
    var gyroz: Double?
    
    // acc values
    var accx: Double?
    var accy: Double?
    var accz: Double?
}

struct DebugMsg {
    var time: String
    var message: String
}

struct markerMsg {
    var time: Date
    
}
