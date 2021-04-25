//
//  ViewController.swift
//  HeadingAccelerometer
//
//  Created by Yaser  on 24/4/21.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var arrowImageView: UIImageView!
    let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
                let radians = atan2(( data?.acceleration.y)!,( data?.acceleration.x)!) + ( .pi / 2.0)
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(radians * (-1.0)))
            }
        }
        else {
          print ("Acelerómetro no disponible")
        }
    }


}

