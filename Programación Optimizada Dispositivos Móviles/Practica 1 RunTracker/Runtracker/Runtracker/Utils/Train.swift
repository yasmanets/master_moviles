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
    
    @objc init(date: String, distance: String, time: String) {
        self.date = date
        self.distance = distance
        self.time = time
    }
}


