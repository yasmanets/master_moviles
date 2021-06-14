//
//  EmitViewController.swift
//  beacons
//
//  Created by Yaser  on 10/5/21.
//

import UIKit
import CoreLocation
import CoreBluetooth

class EmitViewController: UIViewController, CBPeripheralManagerDelegate {
    
    @IBOutlet weak var uuidText: UITextField!
    @IBOutlet weak var majorText: UITextField!
    @IBOutlet weak var minorText: UITextField!
    @IBOutlet weak var identityText: UITextField!
    @IBOutlet weak var emitLabel: UILabel!
    var beaconRegion: CLBeaconRegion!
    var beaconPreripheralData: NSDictionary!
    var peripheralManager: CBPeripheralManager!
    var isEmitting: Bool = false
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if (peripheral.state == .poweredOn) {
            self.peripheralManager.startAdvertising(self.beaconPreripheralData as? [String: Any])
            print("Powered On")
        }
        else {
            self.peripheralManager.stopAdvertising()
            print("Some error")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func createBeaconRegion() {
        let proximityUUID = UUID(uuidString: self.uuidText.text!)
        let major : CLBeaconMajorValue = CLBeaconMajorValue.init((self.majorText.text as NSString?)!.floatValue)
        let minor : CLBeaconMinorValue = CLBeaconMinorValue.init((self.minorText.text as NSString?)!.floatValue)
        let beaconID = self.identityText.text!
            
        self.beaconRegion = CLBeaconRegion(uuid: proximityUUID!, major: major, minor: minor, identifier: beaconID)
    }

    @IBAction func transmit(_ sender: Any) {
        if !isEmitting {
            self.createBeaconRegion()
            self.beaconPreripheralData = self.beaconRegion?.peripheralData(withMeasuredPower: nil)
            self.peripheralManager = CBPeripheralManager.init(delegate: self, queue: nil)
            self.peripheralManager.startAdvertising(self.beaconPreripheralData as? [String: Any])
            self.emitLabel.text = "Transmitiendo"
            self.isEmitting = true
        }
        else {
            self.peripheralManager.stopAdvertising()
            self.emitLabel.text = "Sin transmitir"
            self.isEmitting = false
        }
        
    }
}
