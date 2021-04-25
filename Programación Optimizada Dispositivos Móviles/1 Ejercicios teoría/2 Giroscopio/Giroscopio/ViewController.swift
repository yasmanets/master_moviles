//
//  ViewController.swift
//  Giroscopio
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
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.1
            motionManager.startGyroUpdates(to: OperationQueue.main) { (data, error) in
                print(data ?? "data es null")
            }
        }
        else {
            print ("Giroscopio no disponible")
        }
    }
}

