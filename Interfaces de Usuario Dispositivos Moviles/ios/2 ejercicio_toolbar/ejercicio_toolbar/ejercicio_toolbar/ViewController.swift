//
//  ViewController.swift
//  ejercicio_toolbar
//
//  Created by Yaser  on 13/11/2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var segmentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.segmentLabel.text = "Segmento 1" // default value
        let iv = UIImageView(image: UIImage(named: "fondo_madera.png"))
        iv.frame = CGRect(x: 0, y: 0, width:self.toolbar.frame.size.width, height: 44)
        iv.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        
        self.toolbar.insertSubview(iv, at: 0)
        
        self.textField.textColor = UIColor.white
        self.textField.borderStyle = UITextField.BorderStyle.none
        self.textField.background = UIImage(named: "fondo_textfield.png")
        self.textField.placeholder = "Escribe aquí"
    }
    
    @IBAction func segmentedControlIndexChanged(_ sender: Any) {
        self.segmentLabel.text = self.segmentedControl.selectedSegmentIndex == 0 ? "Segmento 1" : "Segmento 2"
    }


}

