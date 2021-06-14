//
//  ViewController.swift
//  ChatFirebase
//
//  Created by Otto Colomina Pardo on 18/1/18.
//  Copyright © 2018 Universidad de Alicante. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var usuarioText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapBotonEntrar(_ sender: Any) {
        print("Se quiere hacer login con usuario: \(self.usuarioText.text!) y contraseña: \(self.passwordText.text!) ")
        
        let email = self.usuarioText.text!
        let password = self.passwordText.text!
        print("Aquí se debería hacer login en Firebase")
        Auth.auth().signIn(withEmail: email, password: password) {
            (result, error) in
            if let error = error {
                print("Error \(error)")
            }
            else {
                print("Login de: \(result?.user.email ?? "yeda1")")
                self.performSegue(withIdentifier: "login", sender: self)
            }
        }
    }
    
    
    @IBAction func miUnwind(segue: UIStoryboardSegue) {
        
    }


}

