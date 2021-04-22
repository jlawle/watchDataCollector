//
//  sensorParam.swift
//  watchSensorData-v1
//
//  Created by John Lawler on 4/22/21.
//

import Foundation
import UIKit
import CoreMotion


// data sent from the watch
class sensorParam: Codable {
    var time: Date?
    
    // gyro values
    var gyrox: Double?
    var gyroy: Double?
    var gyroz: Double?
    
    // acc values
    var accx: Double?
    var accy: Double?
    var accz: Double?
    
    var magx: Double?
    var magy: Double?
    var magz: Double?
    
    init() {}
}
