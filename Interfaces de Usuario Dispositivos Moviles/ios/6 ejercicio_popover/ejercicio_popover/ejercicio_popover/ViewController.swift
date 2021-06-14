//
//  ViewController.swift
//  ejercicio_popover
//
//  Created by Yaser  on 14/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate, TableViewControllerDelegate {
    func optionSeleccionada(nombreOpcion: String) {
        print("Seleccionado \(nombreOpcion)")
        self.dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func accionOpciones() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "tablaStoryboard") as! TableViewController
        controller.delegate = self
        
        controller.modalPresentationStyle = UIModalPresentationStyle.popover
        self.present(controller, animated: true, completion: nil)
        
        let popController = controller.popoverPresentationController
        // Se establecen la posición desde la que sale
        popController?.barButtonItem = self.navigationItem.rightBarButtonItem
        popController?.permittedArrowDirections = UIPopoverArrowDirection.any
        popController?.delegate = self
        controller.preferredContentSize = CGSize(width: 250, height: 135)
    }


}

