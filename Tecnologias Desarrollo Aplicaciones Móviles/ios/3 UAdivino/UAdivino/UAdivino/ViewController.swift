//
//  ViewController.swift
//  UAdivino
//
//  Created by Yaser  on 28/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let amiAdivino = Adivino()
    @IBOutlet weak var labelRespuesta: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func botonPulsado(_ sender: Any) {
        let respuesta = self.amiAdivino.obtenerRespuesta()
        self.labelRespuesta.text = NSLocalizedString(respuesta, comment: "")
    }
    
}

