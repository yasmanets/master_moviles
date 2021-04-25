//
//  ViewController.swift
//  Acelerometro
//
//  Created by Yaser  on 24/4/21.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Acelerómetro
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
                print(data ?? "data es null")
            }
        }
        else {
          print ("Acelerómetro no disponible")
        }
    }
}

