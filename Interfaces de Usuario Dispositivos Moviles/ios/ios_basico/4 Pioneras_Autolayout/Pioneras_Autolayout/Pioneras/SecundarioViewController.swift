//
//  SecundarioViewController.swift
//  Pioneras
//
//  Created by Yaser  on 19/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class SecundarioViewController: UIViewController {

    @IBOutlet weak var textField: UITextView!
    var nomFich: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nomFich = Bundle.main.path(forResource: self.nomFich!, ofType: "txt")
        do {
            try textField?.text = String(contentsOfFile: nomFich!, encoding: String.Encoding.utf8)
        }
        catch {
            textField?.text = "Ha ocurrido un error"
            print("Ha ocurrido un error")
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
