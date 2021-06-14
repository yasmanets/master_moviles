//
//  ViewController.swift
//  P2PConnectivity
//
//  Created by Yaser  on 2/5/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var textToSend: UITextField!
    @IBOutlet weak var connectionsLabel: UILabel!
    @IBOutlet weak var textRecivedLabel: UILabel!
    
    let sendTextService = SendTextService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sendTextService.delegate = self
    }

    @IBAction func sendText(_ sender: Any) {
        let text = self.textToSend.text ?? "Texto vacío"
        self.sendTextService.send(text: text)
        print("Se envía")
    }
}

extension ViewController: SendTextServiceDelegate {
    
    func connectedDevicesChanged(manager: SendTextService, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.connectionsLabel.text = "\(connectedDevices)"
        }
    }
    
    func sendTextService(didRecive text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-ES")
        let synthesizer = AVSpeechSynthesizer()
        OperationQueue.main.addOperation {
            synthesizer.speak(utterance)
            self.textRecivedLabel.text = text
            print("Se recive"ex)
        }
    }
}
