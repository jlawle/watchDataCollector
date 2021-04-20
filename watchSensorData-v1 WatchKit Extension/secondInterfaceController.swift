//
//  secondInterfaceController.swift
//  watchSensorData-v1 WatchKit Extension
//
//  Created by Cameron Burroughs on 4/19/21.
//
//  This is the interface controller for the second screen that displays the markers
//

import WatchKit
import Foundation


class secondInterfaceController: WKInterfaceController {
    @IBOutlet weak var markTable: WKInterfaceTable!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Note about efficiency (CB): this function starts back at x=0 each time
        // the marker button is pressed and refreshed the table which isn't super efficient,
        // but upon further research, refreshing the table each time is the normal method
        // in every documentation I found
        
        // Configure interface objects here.
        if context is [markerMsg] {
            let array = context as! [markerMsg]
            markTable.setNumberOfRows(array.count, withRowType: "cell")
            var index = 0
            var timeStr: String
            for entry in array as [markerMsg] {
                let row = markTable.rowController(at: index) as! rowController
                timeStr = timeFormatter(date: entry.time)
                row.markLabel.setText("Marker \(index+1): \(timeStr)")
                index += 1
            }
        }
        

    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

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
    
}
