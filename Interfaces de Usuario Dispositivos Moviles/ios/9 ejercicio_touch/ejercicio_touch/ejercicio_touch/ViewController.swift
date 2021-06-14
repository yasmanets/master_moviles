//
//  ViewController.swift
//  ejercicio_touch
//
//  Created by Yaser  on 18/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var touchImage = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.isMultipleTouchEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            print("Touches began")
            
            let touchCount = event!.allTouches!.count
            let tapCount = touch.tapCount
            
            print("Finger count: \(touchCount)")
            print("Tap count: \(tapCount)")
            
            let loc = touch.location(in: self.view)
            if self.imageView.frame.contains(loc) {
                print("Detectado toque sobre la imagen")
                self.touchImage = true
            }
            if self.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
                print ("Force: \(touch.force) from \(touch.maximumPossibleForce)")
            }
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            print("Touches moved")
            let loc = touch.location(in: self.view)
            if self.touchImage == true {
                self.imageView.center = loc
            }
        }
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches ended")
        self.touchImage = false
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches cancelled")
        self.touchImage = false
        super.touchesCancelled(touches, with: event)
    }


}

