//
//  ViewController.swift
//  FullPedometer
//
//  Created by Yaser  on 24/4/21.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var contando = false
    let pedometer = CMPedometer()

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stepsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.stepsLabel?.textColor = UIColor.black
        self.stepsLabel?.text = "0"
    }

    @IBAction func StartButton(_ sender: Any) {
        if contando == false {
            contando = true
            self.stepsLabel?.textColor = UIColor.black
            self.stepsLabel?.text = "0"
            self.startButton.setTitle("FINALIZAR", for: .normal)
            pedometer.startUpdates(from: Date()) { (data, error) in
                DispatchQueue.main.async {
                    self.stepsLabel?.text = data?.numberOfSteps.stringValue
                }
            }
        }
        else {
            contando = false
            pedometer.stopUpdates()
            self.startButton.setTitle("EMPEZAR", for: .normal)
            self.stepsLabel.textColor = UIColor.red
        }
    }
}

