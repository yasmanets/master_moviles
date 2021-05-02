//
//  OptionsTableViewCell.swift
//  Runtracker
//
//  Created by Yaser  on 26/4/21.
//

import UIKit

class OptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var buttonLabel: UIButton!
    @IBOutlet weak var controller: UIViewController!
    public var switchButton: UISwitch!
    let userDefaults = UserDefaults()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func cellButton(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            displayCadence()
        case 2:
            displayInterval()
        case 3:
            displayGPSConfig()
        default:
            break
        }
    }
    
    // MARK: - Alert para introducir la cadencia
    func displayCadence() {
        let alertController = UIAlertController(title: "Candecia", message: "Introduce la cadencia mínima para activar la notificación.", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            let cadence = self.userDefaults.integer(forKey: "cadence")
            if (cadence != 0) {
                textField.placeholder = "Cadencia activada: \(cadence)"
            }
            else {
                textField.placeholder = "Introduce aquí la cedencia..."
            }
        }
        let action = UIAlertAction(title: "OK", style: .default, handler: { alert -> Void in
            let textField = (alertController.textFields?[0])! as UITextField
            self.userDefaults.setValue(Int(textField.text!), forKey: "cadence")
            self.userDefaults.synchronize()
        })
        alertController.addAction(action)
        controller.present(alertController, animated: true)
    }
    
    // MARK: - Alert para introducir  los intervalos
    func displayInterval() {
        let alertController = UIAlertController(title: "Intervalos", message: "Introduce el intervalo de tiempo (metros) o distancia (minutos) para activar la notificación. ", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            let intervalValue = self.userDefaults.integer(forKey: "intervalValue")
            let intervalKey = self.userDefaults.string(forKey: "intervalKey")
            if (intervalKey != nil && !intervalKey!.isEmpty) {
                if (intervalKey == "time") {
                    textField.placeholder = "Intervalo de tiempo: \(intervalValue) min"
                }
                else {
                    textField.placeholder = "Intervalo de distancia: \(intervalValue) m"
                }
            }
            else {
                textField.placeholder = "Introduce el valor del intervalo"
            }
        }
        let timeAction = UIAlertAction(title: "Tiempo (min)", style: .default, handler: { alert -> Void in
            let textField = (alertController.textFields?[0])! as UITextField
            self.userDefaults.setValue(Int(textField.text!), forKey: "intervalValue")
            self.userDefaults.setValue("time", forKey: "intervalKey")
            self.userDefaults.synchronize()
        })
        let distanceAction = UIAlertAction(title: "Distancia (m)", style: .default, handler: { alert -> Void in
            let textField = (alertController.textFields?[0])! as UITextField
            self.userDefaults.setValue(Int(textField.text!), forKey: "intervalValue")
            self.userDefaults.setValue("distance", forKey: "intervalKey")
            self.userDefaults.synchronize()
        })
        let cancelAtion = UIAlertAction(title: "Cancelar", style: .cancel, handler: { alert in
            self.userDefaults.setValue(0, forKey: "intervalValue")
            self.userDefaults.setValue("", forKey: "intervalKey")
            self.userDefaults.synchronize()
        })
        
        alertController.addAction(timeAction)
        alertController.addAction(distanceAction)
        alertController.addAction(cancelAtion)
        controller.present(alertController, animated: true)
    }
    
    // MARK: - Alert para introducir la configuración del GPS
    func displayGPSConfig() {
        let alertController = UIAlertController(title: "Configuración GPS", message: "Introduce la configuración de uso del GPS", preferredStyle: .alert)
        let optimalAction = UIAlertAction(title: "Óptima", style: .default, handler: { alert in
            self.userDefaults.setValue("optimal", forKey: "gps")
            self.userDefaults.synchronize()
        })
        let mediumAction = UIAlertAction(title: "Media", style: .default, handler: { alert in
            self.userDefaults.setValue("medium", forKey: "gps")
            self.userDefaults.synchronize()
        })
        let lowAction = UIAlertAction(title: "Baja", style: .default, handler: { alert in
            self.userDefaults.setValue("low", forKey: "gps")
            self.userDefaults.synchronize()
        })
        alertController.addAction(optimalAction)
        alertController.addAction(mediumAction)
        alertController.addAction(lowAction)
        controller.present(alertController, animated: true)
    }
    
    // MARK: - Funcionalidades del switch
    func createSwitch() {
        let switchView = UISwitch(frame: CGRect(x: self.buttonLabel.frame.origin.x, y: self.buttonLabel.frame.origin.y, width: 0, height: 0))
        switchView.addTarget(self, action: #selector(self.switchStateDidChange(_:)), for: .valueChanged)
        let autopause = userDefaults.bool(forKey: "autopause")
        switchView.setOn(autopause, animated: true)
        self.addSubview(switchView)
    }
    
    @objc func switchStateDidChange(_ sender: UISwitch) {
        userDefaults.setValue(sender.isOn, forKey: "autopause")
        userDefaults.synchronize()
    }
}
