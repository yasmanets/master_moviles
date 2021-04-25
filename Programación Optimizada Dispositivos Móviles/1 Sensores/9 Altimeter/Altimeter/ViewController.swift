//
//  ViewController.swift
//  Altimeter
//
//  Created by Yaser  on 25/4/21.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var relativeAltitude: UILabel!
    @IBOutlet weak var pressure: UILabel!
    let altimeter = CMAltimeter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main) { (data, error) in
                self.relativeAltitude.text = String.init(format: "%.1fM", (data?.relativeAltitude.floatValue)!)
                self.pressure.text = String.init(format: "%.2f hPA", (data?.pressure.floatValue)!*10)
            }
        }
    }
}
