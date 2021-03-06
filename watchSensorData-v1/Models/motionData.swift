//
//  motionData.swift
//  watchSensorData-v1
//
//  Created by John Lawler on 4/5/21.
//

import Foundation


struct DebugMsg {
    var time: String
    var message: String
}

struct marker: Codable {
    var time: Date
}

struct markerData: Codable {
    var markers = [marker]()
}

