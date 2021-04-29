//
//  sensorParam.swift
//  watchSensorData-v1
//
//  Created by John Lawler on 4/22/21.
//

import Foundation


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
    
    //attitude
    var roll: Double?
    var pitch: Double?
    var yaw: Double?
    
    // magnometer
    var gravx: Double?
    var gravy: Double?
    var gravz: Double?
    
    init() {}
}
