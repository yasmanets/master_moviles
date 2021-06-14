//
//  Train.swift
//  Runtracker
//
//  Created by Yaser  on 28/4/21.
//

import UIKit

class Train: NSObject, Codable {
    let date: String
    let distance: String
    let time: String
    let calories: Int
    
    @objc init(date: String, distance: String, time: String, calories: Int) {
        self.date = date
        self.distance = distance
        self.time = time
        self.calories = calories
    }
}


