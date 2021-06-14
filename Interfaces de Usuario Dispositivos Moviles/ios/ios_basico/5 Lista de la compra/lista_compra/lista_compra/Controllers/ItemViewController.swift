//
//  ItemViewController.swift
//  lista_compra
//
//  Created by Yaser  on 20/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {

    var name: String = ""
    @IBOutlet weak var itemTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let text = self.itemTextField.text {
            self.name = text
        }
    }

}
