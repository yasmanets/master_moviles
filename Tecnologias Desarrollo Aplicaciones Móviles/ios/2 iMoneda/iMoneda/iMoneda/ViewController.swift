//
//  ViewController.swift
//  iMoneda
//
//  Created by Yaser  on 28/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    let moneda = Moneda()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.resultLabel.text = ""
        self.image.isHidden = true
        
    }

    @IBAction func onClick(_ sender: Any) {
        let tirada: Tirada = moneda.lanzar()
        self.image.isHidden = false
        self.image.image = UIImage(named: tirada.rawValue)
        self.resultLabel.text = "¡Ha salido \(tirada.rawValue)!"
    }
}

