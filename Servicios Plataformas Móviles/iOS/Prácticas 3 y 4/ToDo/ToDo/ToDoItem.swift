//
//  ToDoItem.swift
//  ToDoList
//
//  Created by Domingo on 12/5/15.
//  Copyright (c) 2015 Universidad de Alicante. All rights reserved.
//

import UIKit
import CloudKit

class ToDoItem: NSObject {
    var nombreItem: String
    var completado: Bool = false
    var fechaFinalizacion: Date? = nil
    var type: Int = 0
   
    init(nombre: String) {
        nombreItem = nombre
    }
}
