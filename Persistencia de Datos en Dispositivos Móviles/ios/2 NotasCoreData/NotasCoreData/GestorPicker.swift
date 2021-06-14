//
//  GestorPicker.swift
//  NotasCoreData
//
//  Created by Yaser  on 12/12/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import Foundation
import UIKit
import CoreData

class GestorPicker: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var libretas = [Libreta]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.libretas.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.libretas[row].nombre
    }
    
    func cargarLista() {
        let miDelegate = UIApplication.shared.delegate as! AppDelegate
        let miContexto = miDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<Libreta>(entityName: "Libreta")
        self.libretas = try! miContexto.fetch(request)
    }
    
    

}
