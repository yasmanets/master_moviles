//
//  DistanceManagement.swift
//  Runtracker
//
//  Created by Yaser  on 27/4/21.
//

import Foundation

class DistanceManagement {
    static func metersToKilometers(meters: Double) -> String {
        var distanceString = "\(meters) m"
        if (meters > 1000) {
            distanceString = "\(Double(round(100 * meters) / 100)) km"
        }
        return distanceString
    }
    
    static func stepsPerMinute(cadence: NSNumber) -> String {
        let steps = cadence as! Int * 60
        return "\(steps)"
    }
    
    static func pacePerMinute(pace: NSNumber) -> String {
        let seconds = pace as! Int * 1000
        let time = TimeManagement.countToTime(seconds: seconds)
        return TimeManagement.timeToString(hours: time.0, minutes: time.1, seconds: time.2)
    }
}
