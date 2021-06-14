//
//  ViewController.swift
//  PersistenciaBasica
//
//  Created by Yaser  on 12/12/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var fechaLabel: UILabel!
    var fechaEdicion: Date!
    let preferences = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let text = preferences.string(forKey: "text") {
            self.textView.text = text
        }
        else {
            self.textView.text = "Introduce un texto"
        }
        
        if self.preferences.object(forKey: "date") != nil {
            let storedDate = self.preferences.object(forKey: "date") as! Date
            self.fechaLabel.text = DateFormatter.localizedString(from: storedDate, dateStyle: .short, timeStyle: .medium)
        }
        else {
            self.fechaLabel.text = "No hay fechas guardadas"

        }
    }


    @IBAction func savePreferences(_ sender: UIButton) {
        self.fechaEdicion = Date()
        self.fechaLabel.text = DateFormatter.localizedString(from: self.fechaEdicion!, dateStyle: .short, timeStyle: .medium)
        preferences.set(self.textView.text, forKey: "text")
        preferences.set(self.fechaEdicion, forKey: "date")
        UserDefaults().synchronize()
    }
}

