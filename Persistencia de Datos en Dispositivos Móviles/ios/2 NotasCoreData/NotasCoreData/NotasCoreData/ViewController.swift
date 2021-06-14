//
//  ViewController.swift
//  NotasCoreData
//
//  Created by Yaser  on 12/12/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    let gestorPicker = GestorPicker()
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noteTextView.text = "Introduce el texto de la nota"
        self.dateLabel.text = ""
        self.messageLabel.text = ""
        
        self.picker.delegate = self.gestorPicker
        self.picker.dataSource = self.gestorPicker
        self.gestorPicker.cargarLista()
        
        if self.gestorPicker.libretas.count == 0 {
            self.createButton.isEnabled = false
            self.saveButton.isEnabled = false
            self.messageLabel.text = "Debes crear una libreta"
        }
    }

    @IBAction func saveNote(_ sender: Any) {
        guard let coreDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let numLibreta = self.picker.selectedRow(inComponent: 0)
        let myContext = coreDelegate.persistentContainer.viewContext
        let note = Nota(context: myContext)
        note.fecha = Date()
        note.texto = self.noteTextView.text
        note.libreta = self.gestorPicker.libretas[numLibreta]
        
        do {
            try myContext.save()
            self.dateLabel.text = DateFormatter.localizedString(from: note.fecha!, dateStyle: .short, timeStyle: .medium)
            self.messageLabel.text = "Nota guardada con éxito!"

        } catch {
            print("Error al guardar el contexto: \(error)")
        }
    }
    
    @IBAction func createNewNote(_ sender: Any) {
        self.noteTextView.text = ""
        self.dateLabel.text = ""
        self.messageLabel.text = ""
    }
    
    @IBAction func createNewNoteBook(_ sender: Any) {
        let alert = UIAlertController(title: "Nueva libreta", message: "Escribe el nombre de la libreta", preferredStyle: .alert)
        let crear = UIAlertAction(title: "Crear", style: .default) {
            action in
            guard let coreDelegate = UIApplication.shared.delegate as? AppDelegate else{
                return
            }
            let myContext = coreDelegate.persistentContainer.viewContext
            let nombre = alert.textFields![0].text!
            
            let noteBook = Libreta(context: myContext)
            noteBook.nombre = nombre
            
            do {
                try myContext.save()
                self.gestorPicker.libretas.append(noteBook)
                self.picker.reloadAllComponents()
                self.messageLabel.text = "Libreta guardada con éxito!"
                self.createButton.isEnabled = true
                self.saveButton.isEnabled = true

            } catch {
                print("Error al guardar el contexto: \(error)")
            }
        }
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel) {
            action in
        }
        alert.addAction(crear)
        alert.addAction(cancelar)
        alert.addTextField() { $0.placeholder = "Nombre" }
        self.present(alert, animated: true)
    }
}

