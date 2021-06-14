//
//  Restaurant.swift
//  MisTenedores
//
//  Created by Yaser  on 30/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class Restaurant {
    var name: String
    var type: String
    var image: UIImage!
    var bestPlates: [String]!
    var location: String
    var phone: String
    var web: String
    var rating: String = "rating"
    
    init(name: String, type: String, image: UIImage, bestPlates: [String]!, phone: String, web: String, location: String) {
        self.name = name
        self.type = type
        self.image = image
        self.bestPlates = bestPlates
        self.phone = phone
        self.web = web
        self.location = location
        
    }
}
