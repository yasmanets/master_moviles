//
//  ChatViewController.swift
//  ChatFirebase
//
//  Created by Otto Colomina Pardo on 18/1/18.
//  Copyright © 2018 Universidad de Alicante. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var usuarioLabel: UILabel!
    @IBOutlet weak var mensajeText: UITextField!
    @IBOutlet weak var miTabla: UITableView!
    var mensajes : [Mensaje] = []
    let database = Database.database()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Nosotros somos el delegado de la tabla
        self.miTabla.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.usuarioLabel.text = Auth.auth().currentUser?.email
        let messageReference = database.reference(withPath: "mensajes")
        messageReference.observe(.childAdded) {
            snapshot in
            if let valor = snapshot.value, let v = valor as? [String:String] {
                self.mensajes.append(Mensaje(texto: v["texto"]!, usuario: v["usuario"]!))
                let indexPath = IndexPath(row: self.mensajes.count-1, section: 0)
                self.miTabla.insertRows(at: [indexPath], with: .bottom)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapBotonEnviar(_ sender: Any) {
        let messageReference = database.reference(withPath: "mensajes")
        let newNode = messageReference.childByAutoId()
        newNode.setValue(["texto": self.mensajeText.text, "usuario": self.usuarioLabel.text])
        self.mensajeText.text = ""
    }
    
    @IBAction func tapBotonSalir(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error cerrando la sesión: \(signOutError)")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mensajes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nuevaCelda = tableView.dequeueReusableCell(withIdentifier: "CeldaMensaje", for: indexPath)
        nuevaCelda.textLabel?.text = self.mensajes[indexPath.row].texto
        nuevaCelda.detailTextLabel?.text = self.mensajes[indexPath.row].usuario
        return nuevaCelda
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
