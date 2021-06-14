//
//  ViewController.swift
//  NavegacionStoryboard
//
//  Created by Yaser  on 18/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "siguiente" {
            if let vc2 = segue.destination as? ViewControllerSecundario {
                vc2.mensaje = textField.text!
            }
        }
    }
    
    @IBAction func miUnwind(segue: UIStoryboardSegue) {
        print("Volviendo atrás por \(String(describing: segue.identifier))...")
    }


}

