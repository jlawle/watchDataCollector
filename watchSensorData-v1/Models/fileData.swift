//
//  fileData.swift
//  watchSensorData-v1
//
//  Created by John Lawler on 4/22/21.
//

import Foundation

class fileData: Codable {
    var duration: String?
    var sensorData = [sensorParam]()
}
