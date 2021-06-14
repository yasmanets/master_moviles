//
//  ViewController.swift
//  dashboard
//
//  Created by Yaser  on 19/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sliderView: UISlider!
    @IBOutlet weak var velocityLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var travelPicker: UIPickerView!
    let picker = TravelPicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField?.tag = 10
        textView?.backgroundColor = UIColor.init(displayP3Red: 255, green: 0, blue: 0, alpha: 0.3)
        textView?.textColor = UIColor.init(displayP3Red: 0, green: 0, blue: 0, alpha: 1)
        
        sliderView?.minimumValue = 0
        sliderView?.maximumValue = 100
        sliderView?.value = 0
        velocityLabel?.text = "0"
        
        button?.tintColor = UIColor.red
        
        self.travelPicker.delegate = self.picker
        self.travelPicker.dataSource = self.picker
        
    }
    
    @IBAction func enterClicked(_ sender: UITextField) {
        sender.resignFirstResponder()
        textView?.text += "\(textField.text!) \n"
        textField?.text = ""
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Se ha tocado la pantalla")
        self.view.viewWithTag(10)?.resignFirstResponder()
        textView?.text += "\(textField.text!) \n"
        textField?.text = ""
    }
    
    @IBAction func onSliderChanged(_ sender: Any) {
        velocityLabel?.text = "\(Int(sliderView.value))"
    }
    
    @IBAction func showAlert(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Opciones", message: "Selecciona una opción", preferredStyle: .actionSheet)
        let salvavidas = UIAlertAction(title: "Nave salvavidas", style: .default) {
            action in
            print("Se despliegua una nave salvavidas")
        }
        let hiperespacio = UIAlertAction(title: "Hiperespacio", style: .default) {
            action in
            print("Salto de la nave y me voy al hiperespacio")
        }
        let autodestruccion = UIAlertAction(title: "Autodestrucción", style: .destructive) {
            action in
            print("Simplemente, adios...")
        }
        actionSheet.addAction(salvavidas)
        actionSheet.addAction(hiperespacio)
        actionSheet.addAction(autodestruccion)
        self.present(actionSheet, animated: true) {
            print("Acaba la animación")
        }
    }
    
    @IBAction func onSwitchChanged(_ sender: Any) {
        if switchView!.isOn {
            button.isEnabled = true
        }
        else {
            button.isEnabled = false
        }
    }
    
}

