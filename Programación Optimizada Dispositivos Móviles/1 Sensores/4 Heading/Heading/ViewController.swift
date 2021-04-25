//
//  ViewController.swift
//  Heading
//
//  Created by Yaser  on 24/4/21.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var arrowUIImage: UIImageView!
    let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
                let radians = atan2((motion?.gravity.y)!, (motion?.gravity.x)! + (.pi / 2.0))
                self.arrowUIImage.transform = CGAffineTransform(rotationAngle: CGFloat(radians * (-1.0)))
            }
        }
    }


}

