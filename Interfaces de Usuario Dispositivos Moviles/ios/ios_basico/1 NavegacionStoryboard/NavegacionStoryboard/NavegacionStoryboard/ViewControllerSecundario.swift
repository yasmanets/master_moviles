//
//  ViewControllerSecundario.swift
//  NavegacionStoryboard
//
//  Created by Yaser  on 19/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class ViewControllerSecundario: UIViewController {
    
    var mensaje = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hola soy el controlador secundario")
        print(self.mensaje)
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
