//
//  ViewController.swift
//  CapturaVideoOpenCV
//
//  Created by Master Móviles on 17/11/16.
//  Copyright © 2016 Master Móviles. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var sliderBlur: UISlider!
    @IBOutlet weak var sliderCanny1: UISlider!
    @IBOutlet weak var sliderCanny2: UISlider!

    var videoCameraWrapper : CvVideoWrapper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.videoCameraWrapper = CvVideoWrapper(controller:self, andImageView:imagen)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func valueChangedBlur(sender: UISlider) {
        self.videoCameraWrapper.blurValue = sender.value
        NSLog("Blur Value: \(sender.value)")
    }

    @IBAction func valueChangedCanny1(sender: UISlider) {
        self.videoCameraWrapper.canny1Value = sender.value
        NSLog("Canny 1 Value: \(sender.value)")
    }

    @IBAction func valueChangedCanny2(sender: UISlider) {
        self.videoCameraWrapper.canny2Value = sender.value
        NSLog("Canny 2 Value: \(sender.value)")
    }

}

