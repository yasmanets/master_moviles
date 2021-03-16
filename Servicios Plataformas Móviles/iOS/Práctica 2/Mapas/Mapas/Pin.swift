//
//  Pin.swift
//  Mapas
//
//  Created by Yaser  on 21/2/21.
//

import Foundation
import MapKit

class Pin:  NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var thumbImage: UIImage

    init(num: Int, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = "Pin \(num)"
        self.subtitle = subtitle
        self.coordinate = coordinate
        if (num % 2 == 0) {
            self.thumbImage = UIImage(named: "btc.png")!
        } else {
            self.thumbImage = UIImage(named: "swift.png")!
        }
        super.init()
    }
}
