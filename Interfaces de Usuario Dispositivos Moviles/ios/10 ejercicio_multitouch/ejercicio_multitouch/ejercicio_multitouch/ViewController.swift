//
//  ViewController.swift
//  ejercicio_multitouch
//
//  Created by Yaser  on 18/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        let pan = UIPanGestureRecognizer(target: self, action:#selector(handlePan))
        let rotation = UIRotationGestureRecognizer(target: self, action:#selector(handleRotation))
        let pinch = UIPinchGestureRecognizer(target: self, action:#selector(handlePinch))
        
        tap.delegate = self
        pan.delegate = self
        rotation.delegate = self
        pinch.delegate = self
        
        self.imageView.addGestureRecognizer(tap)
        self.imageView.addGestureRecognizer(pan)
        self.imageView.addGestureRecognizer(rotation)
        self.imageView.addGestureRecognizer(pinch)
    }
    
    @objc func handleTap(sender: UIGestureRecognizer) {
        print("Tap")
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        print("Pan")
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
    }

    @objc func handleRotation(sender: UIRotationGestureRecognizer) {
        print("Rotation")
        if let view = sender.view {
            view.transform = view.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        }
    }

    @objc func handlePinch(sender: UIPinchGestureRecognizer) {
        print("Pinch")
        if let view = sender.view {
            view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1;
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @IBAction func handleLongPress(_ sender: Any) {
        print("Long press")
    }
    
}

