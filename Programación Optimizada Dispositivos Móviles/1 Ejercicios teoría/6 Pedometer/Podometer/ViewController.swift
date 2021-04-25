//
//  ViewController.swift
//  Podometer
//
//  Created by Yaser  on 24/4/21.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    let pedometer = CMPedometer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if CMPedometer.isStepCountingAvailable() {
            let calendar = Calendar.current
            pedometer.queryPedometerData(from: calendar.startOfDay(for: Date()), to: Date()) { (data, error) in
                print(data ?? "Dato no disponible")
            }
        }
    }
}

