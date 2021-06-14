//
//  Pelicula.swift
//  ejercicio_universal
//
//  Created by Yaser  on 15/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class Pelicula {
    var titulo: String
    var caratula: String
    var fecha: String
    var descripcion: String?
    var actores: [String]?
    
    init(titulo: String, caratula: String, fecha: String, descripcion: String?, actores: [String]?) {
        self.titulo = titulo
        self.caratula = caratula
        self.fecha = fecha
        self.descripcion = descripcion
        self.actores = actores
    }
}
